class Admin::InfrastructureTypesController < Admin::BaseNomenclatureController
  
  def index
    @infrastructure_types = InfrastructureType.all
  end
  
  def show
    @infrastructure_type = InfrastructureType.find(params[:id])
  end
  
  def new
    @infrastructure_type = InfrastructureType.new
  end
  
  def create
    @infrastructure_type = InfrastructureType.new(params[:infrastructure_type])
    if @infrastructure_type.save
      redirect_to admin_infrastructure_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @infrastructure_type = InfrastructureType.find(params[:id])
  end
  
  def update
    @infrastructure_type = InfrastructureType.find(params[:id])
    if @infrastructure_type.update_attributes(params[:infrastructure_type])
      redirect_to admin_infrastructure_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @infrastructure_type = InfrastructureType.find(params[:id])
    @infrastructure_type.destroy
    redirect_to admin_infrastructure_types_url
  end
  
end
