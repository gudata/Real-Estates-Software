class Admin::ExposureTypesController < Admin::BaseNomenclatureController
  
  def index
    @exposure_types = ExposureType.all
  end
  
  def show
    @exposure_type = ExposureType.find(params[:id])
  end
  
  def new
    @exposure_type = ExposureType.new
  end
  
  def create
    @exposure_type = ExposureType.new(params[:exposure_type])
    if @exposure_type.save
      redirect_to admin_exposure_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @exposure_type = ExposureType.find(params[:id])
  end
  
  def update
    @exposure_type = ExposureType.find(params[:id])
    if @exposure_type.update_attributes(params[:exposure_type])
      redirect_to admin_exposure_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @exposure_type = ExposureType.find(params[:id])
    @exposure_type.destroy
    redirect_to admin_exposure_types_url
  end
  
end
