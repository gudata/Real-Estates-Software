class Admin::QuartersController < Admin::BaseNomenclatureController
  # Working with Globalize2 translations models
  # Examples:
  # Quarter.translations_name_like_and_city_id("1").all(:joins => :translations) -> array
  # Quarter.search(:translations_name_like => "1", :city_id => 1).all(:joins => :translations) -> array
  # City.search(:quarters_translations_name_like => "1", :quarters_city_id_equals => 1).all(:joins => {:quarters => :translations}) -> array

  before_filter :get_city
  
  def get_city
    @city = City.find(params[:city_id])
  end

  def index
    params[:name] = '' unless params[:name]
    if params[:order]
      if params[:order] == "DESC"
        order = ["quarter_translations.name", params[:order]].join(" ")
        @set_order =  "ASC"
      else
        order = ["quarter_translations.name", params[:order]].join(" ")
        @set_order =  "DESC"
      end
    else
      order = "created_at ASC"
      @set_order = "ASC"
    end
   
    @quarters = Quarter.paginate(:joins => :translations,
      :conditions => ["quarter_translations.name LIKE ? AND quarters.city_id = ?", "%#{params[:name]}%", @city.id],
      :order =>  order,
      :page => params[:page]
    )
  end
  
  def show
    @quarter = Quarter.find(params[:id])
  end
  
  def new
    @quarter = @city.quarters.new
  end

  def add_multiple
    @quarter = @city.quarters.new
  end

  def do_add_multiple
    names = params[:quarter][:name]
    params[:quarter].delete :name
    if names.blank? || names.strip.blank?
      flash[:error] = t("no_names", :scope => [:admin, :quarters, :add_multiple])
      redirect_to admin_city_quarters_url
    end
    attributes = params[:quarter]
    counter = 0
    names.split(/\n/).each do |name|
      quarter = Quarter.new(attributes)
      quarter.name = name
      quarter.city = @city
      quarter.save
      counter += 1
    end
    
    flash["success"] = t("saved", :scope => [:admin, :quarters, :add_multiple], :count => counter)
    redirect_to add_multiple_admin_city_quarters_path(:city_id => @city.id)
  end
  
  def create

    @quarter = Quarter.new(params[:quarter])
    @quarter.city = @city

    if @quarter.save
      flash[:notice] = "Successfully created quarter."
      redirect_to admin_city_quarters_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @quarter = Quarter.find(params[:id])
  end
  
  def update
    @quarter = Quarter.find(params[:id])
    @quarter.city = @city
    if @quarter.update_attributes(params[:quarter])
      flash[:notice] = "Successfully updated quarter."
      redirect_to admin_city_quarters_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @quarter = Quarter.find(params[:id])
    @quarter.destroy
    flash[:notice] = "Successfully destroyed quarter."
    redirect_to admin_city_quarters_url
  end
end
