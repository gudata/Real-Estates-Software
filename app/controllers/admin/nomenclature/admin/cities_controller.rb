class Admin::CitiesController < Admin::BaseNomenclatureController

  def index
    condition_part1 =  []
    condition_part2 =  []
    conditions= ''

    if params[:order]
      if params[:order] == "DESC"
        order = ["city_translations.name", params[:order]].join(" ")
        @set_order =  "ASC"
      else
        order = ["city_translations.name", params[:order]].join(" ")
        @set_order =  "DESC"
      end

    else
      order = "created_at ASC"
      @set_order = "ASC"
    end
    if params[:name] && !params[:name].blank?
      condition_part1 << "city_translations.name LIKE ?"
      condition_part2 << "%#{params[:name]}%".gsub(/\\/, '\&\&').gsub(/'/, "''")
    end
    if params[:district_id] && !(params[:district_id].blank?)
      condition_part1 << "municipalities.district_id = ?"
      condition_part2 << params[:district_id]
    end
    if params[:municipality_id] && !(params[:municipality_id].blank?)
      condition_part1 << "municipality_id = ?"
      condition_part2 << params[:municipality_id]
    end

    conditions = [condition_part1.join(' AND ')]
    conditions << condition_part2
    conditions = conditions.flatten


    @cities = City.paginate(:joins => [:translations, {:municipality => :district}],
      :conditions => conditions,
      :order =>  order,
      :page => params[:page]
    )
  end
  
  def show
    @city = City.find(params[:id])

  end
  
  def new
    @city = City.new
  end
  
  def create
    params[:city] ||= {}
    
    if params[:city][:kind] == '1'
      params[:city][:place_type] = t("1", :scope => [:admin, :cities, :place_types])
    else
      params[:city][:place_type] = t("3", :scope => [:admin, :cities, :place_types])
    end
    @city = City.new(params[:city])
    if @city.save
      flash[:notice] = "Successfully created city."
      redirect_to admin_cities_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @city = City.find(params[:id])
  end
  
  def update
    if params[:city][:kind] == '1'
      params[:city][:place_type] = t('1', :scope => :place_types)
    else
      params[:city][:place_type] = t('3', :scope => :place_types)
    end
    @city = City.find(params[:id])
    if @city.update_attributes(params[:city])
      flash[:notice] = "Successfully updated city."
      redirect_to admin_cities_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @city = City.find(params[:id])
    @city.destroy
    flash[:notice] = "Successfully destroyed city."
    redirect_to admin_cities_url
  end

  def load_districts
    respond_to do |format|
      format.js {
        @collection = District.find_all_by_country_id(params[:country_id])
        @name_method = :name
        @replace_selector = params[:replace_selector] || "district_id"
        render :action => "ajax_options"
      }
    end
  end

  def load_municipalities
    respond_to do |format|
      format.js {
        @collection = Municipality.find_all_by_district_id(params[:district_id])
        @name_method = :name
        @replace_selector = params[:replace_selector] || "municipality_id"
        render :action => "ajax_options"
      }
    end
  end

  def load_places
    respond_to do |format|
      format.js {
        if params[:country_id]
          districts = Country.find(params[:country_id]).districts
          municipalities = districts.empty? ? [] : districts.first.municipalities
          @update_options = [[:district_id, districts], [:municipality_id, municipalities]]
        elsif params[:district_id]
          municipalities = District.find(params[:district_id]).municipalities          
          @update_options = [[:municipality_id, municipalities]]
        else
          render :nil
        end
      }
    end
  end


end
