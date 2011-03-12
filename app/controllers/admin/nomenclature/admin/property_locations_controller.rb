class Admin::PropertyLocationsController < Admin::BaseController
  
  def index
    @property_locations = PropertyLocation.paginate(:page => params[:page])
  end
  
  def show
    @property_location = PropertyLocation.find(params[:id])
  end
  
  def new
    @property_location = PropertyLocation.new
  end
  
  def create
    @property_location = PropertyLocation.new(params[:property_location])
    if @property_location.save
      redirect_to admin_property_locations_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @property_location = PropertyLocation.find(params[:id])
  end
  
  def update
    @property_location = PropertyLocation.find(params[:id])
    if @property_location.update_attributes(params[:property_location])
      redirect_to admin_property_locations_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @property_location = PropertyLocation.find(params[:id])
    @property_location.destroy
    redirect_to admin_property_locations_url
  end
  
end
