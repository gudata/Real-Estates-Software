class Admin::ValidationTypesController < Admin::BaseController
  
  def index
    @validation_types = ValidationType.paginate(:page => params[:page])
  end
  
  def show
    @validation_type = ValidationType.find(params[:id])
  end
  
  def new
    @validation_type = ValidationType.new
  end
  
  def create
    @validation_type = ValidationType.new(params[:validation_type])
    if @validation_type.save
      redirect_to admin_validation_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @validation_type = ValidationType.find(params[:id])
  end
  
  def update
    @validation_type = ValidationType.find(params[:id])
    if @validation_type.update_attributes(params[:validation_type])
      redirect_to admin_validation_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @validation_type = ValidationType.find(params[:id])
    @validation_type.destroy
    redirect_to admin_validation_types_url
  end
  
end
