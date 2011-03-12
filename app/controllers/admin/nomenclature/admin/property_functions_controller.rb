class Admin::PropertyFunctionsController < Admin::BaseNomenclatureController
  
  def index
    @property_functions = PropertyFunction.all
  end
  
  def show
    @property_function = PropertyFunction.find(params[:id])
  end
  
  def new
    @property_function = PropertyFunction.new
  end
  
  def create
    @property_function = PropertyFunction.new(params[:property_function])
    if @property_function.save
      redirect_to admin_property_functions_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @property_function = PropertyFunction.find(params[:id])
  end
  
  def update
    @property_function = PropertyFunction.find(params[:id])
    if @property_function.update_attributes(params[:property_function])
      redirect_to admin_property_functions_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @property_function = PropertyFunction.find(params[:id])
    @property_function.destroy
    redirect_to admin_property_functions_url
  end
  
end
