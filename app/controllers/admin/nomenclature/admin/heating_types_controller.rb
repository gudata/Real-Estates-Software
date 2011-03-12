class Admin::HeatingTypesController < Admin::BaseNomenclatureController
  
  def index
    @heating_types = HeatingType.all
  end
  
  def show
    @heating_type = HeatingType.find(params[:id])
  end
  
  def new
    @heating_type = HeatingType.new
  end
  
  def create
    @heating_type = HeatingType.new(params[:heating_type])
    if @heating_type.save
      redirect_to admin_heating_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @heating_type = HeatingType.find(params[:id])
  end
  
  def update
    @heating_type = HeatingType.find(params[:id])
    if @heating_type.update_attributes(params[:heating_type])
      redirect_to admin_heating_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @heating_type = HeatingType.find(params[:id])
    @heating_type.destroy
    redirect_to admin_heating_types_url
  end
  
end
