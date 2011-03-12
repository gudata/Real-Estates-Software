class Admin::FenceTypesController < Admin::BaseNomenclatureController
  
  def index
    @fence_types = FenceType.all
  end
  
  def show
    @fence_type = FenceType.find(params[:id])
  end
  
  def new
    @fence_type = FenceType.new
  end
  
  def create
    @fence_type = FenceType.new(params[:fence_type])
    if @fence_type.save
      redirect_to admin_fence_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @fence_type = FenceType.find(params[:id])
  end
  
  def update
    @fence_type = FenceType.find(params[:id])
    if @fence_type.update_attributes(params[:fence_type])
      redirect_to admin_fence_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @fence_type = FenceType.find(params[:id])
    @fence_type.destroy
    redirect_to admin_fence_types_url
  end
  
end
