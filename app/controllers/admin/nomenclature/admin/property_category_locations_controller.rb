class Admin::PropertyCategoryLocationsController < Admin::BaseController
  
  def index
    @property_category_locations = PropertyCategoryLocation.paginate(:page => params[:page])
  end
  
  def show
    @property_category_location = PropertyCategoryLocation.find(params[:id])
  end
  
  def new
    @property_category_location = PropertyCategoryLocation.new
  end
  
  def create
    @property_category_location = PropertyCategoryLocation.new(params[:property_category_location])
    if @property_category_location.save
      redirect_to admin_property_category_locations_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @property_category_location = PropertyCategoryLocation.find(params[:id])
  end
  
  def update
    @property_category_location = PropertyCategoryLocation.find(params[:id])
    if @property_category_location.update_attributes(params[:property_category_location])
      redirect_to admin_property_category_locations_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @property_category_location = PropertyCategoryLocation.find(params[:id])
    @property_category_location.destroy
    redirect_to admin_property_category_locations_url
  end
  
end
