class Admin::DistrictsController < Admin::BaseNomenclatureController
  def index
    condition_statement =  []
    condition_params =  []

    if params[:country_id] && !(params[:country_id].blank?)
      condition_statement << "country_id = ?"
      condition_params << params[:country_id]
    end
    if params[:name] && !(params[:name].blank?)
      condition_statement << "name like ?"
      condition_params << "%#{params[:name].strip}%"
    end

    conditions = [condition_statement.join(' AND ')]
    conditions << condition_params
    conditions = conditions.flatten


    @districts = District.paginate(:include => [:translations, [:municipalities]],
      :conditions => conditions,
      :page => params[:page]
    )

  end
  
  def show
    @district = District.find(params[:id])
  end
  
  def new
    @district = District.new
  end
  
  def create
    @district = District.new(params[:district])
    if @district.save
      flash[:notice] = "Successfully created district."
      redirect_to [:admin, @district]
    else
      render :action => 'new'
    end
  end
  
  def edit
    @district = District.find(params[:id])
  end
  
  def update
    @district = District.find(params[:id])
    if @district.update_attributes(params[:district])
      flash[:notice] = "Successfully updated district."
      redirect_to [:admin, @district]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @district = District.find(params[:id])
    @district.destroy
    flash[:notice] = "Successfully destroyed district."
    redirect_to admin_districts_url
  end
end
