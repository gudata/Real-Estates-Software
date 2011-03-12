class Admin::FloorTypesController < Admin::BaseNomenclatureController
  
  def index
    @floor_types = FloorType.all
  end
  
  def show
    @floor_type = FloorType.find(params[:id])
  end
  
  def new
    @floor_type = FloorType.new
  end
  
  def create
    @floor_type = FloorType.new(params[:floor_type])
    if @floor_type.save
      redirect_to admin_floor_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @floor_type = FloorType.find(params[:id])
  end
  
  def update
    @floor_type = FloorType.find(params[:id])
    if @floor_type.update_attributes(params[:floor_type])
      redirect_to admin_floor_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @floor_type = FloorType.find(params[:id])
    @floor_type.destroy
    redirect_to admin_floor_types_url
  end
  
end
