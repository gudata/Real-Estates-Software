class Admin::BuildingTypesController < Admin::BaseNomenclatureController
  
  def index
    @building_types = BuildingType.all
  end
  
  def show
    @building_type = BuildingType.find(params[:id])
  end
  
  def new
    @building_type = BuildingType.new
  end
  
  def create
    @building_type = BuildingType.new(params[:building_type])
    if @building_type.save
      redirect_to admin_building_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @building_type = BuildingType.find(params[:id])
  end
  
  def update
    @building_type = BuildingType.find(params[:id])
    if @building_type.update_attributes(params[:building_type])
      redirect_to admin_building_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @building_type = BuildingType.find(params[:id])
    @building_type.destroy
    redirect_to admin_building_types_url
  end
  
end
