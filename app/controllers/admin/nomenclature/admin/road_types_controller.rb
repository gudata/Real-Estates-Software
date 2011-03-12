class Admin::RoadTypesController < Admin::BaseNomenclatureController
  
  def index
    @road_types = RoadType.all
  end
  
  def show
    @road_type = RoadType.find(params[:id])
  end
  
  def new
    @road_type = RoadType.new
  end
  
  def create
    @road_type = RoadType.new(params[:road_type])
    if @road_type.save
      redirect_to admin_road_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @road_type = RoadType.find(params[:id])
  end
  
  def update
    @road_type = RoadType.find(params[:id])
    if @road_type.update_attributes(params[:road_type])
      redirect_to admin_road_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @road_type = RoadType.find(params[:id])
    @road_type.destroy
    redirect_to admin_road_types_url
  end
  
end
