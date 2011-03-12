class Admin::MunicipalitiesController < Admin::BaseNomenclatureController
  
  def index

    condition_part1 =  []
    condition_part2 =  []
    conditions= ''

    if params[:name] && !params[:name].blank?
      condition_part1 << "municipality_translations.name LIKE ?"
      condition_part2 << "%#{params[:name]}%".gsub(/\\/, '\&\&').gsub(/'/, "''")
    end
    if params[:district_id] && !(params[:district_id].blank?)
        condition_part1 << "municipalities.district_id = ?"
        condition_part2 << params[:district_id]
    end

    conditions = [condition_part1.join(' AND ')]
    conditions << condition_part2
    conditions = conditions.flatten


    @municipalities = Municipality.paginate(:joins => :translations, :conditions => conditions, :page => params[:page])
  end
  
  def show
    @municipality = Municipality.find(params[:id])
  end
  
  def new
    @municipality = Municipality.new
  end
  
  def create
    @municipality = Municipality.new(params[:municipality])
    if @municipality.save
      redirect_to admin_municipalities_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @municipality = Municipality.find(params[:id])
  end
  
  def update
    @municipality = Municipality.find(params[:id])
    if @municipality.update_attributes(params[:municipality])
      redirect_to admin_municipalities_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @municipality = Municipality.find(params[:id])
    @municipality.destroy
    redirect_to admin_municipalities_url
  end

end
