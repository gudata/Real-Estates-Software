class Admin::PhoneTypesController < Admin::BaseNomenclatureController
  
  def index
    @phone_types = PhoneType.all
  end
  
  def show
    @phone_type = PhoneType.find(params[:id])
  end
  
  def new
    @phone_type = PhoneType.new
  end
  
  def create
    @phone_type = PhoneType.new(params[:phone_type])
    if @phone_type.save
      redirect_to admin_phone_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @phone_type = PhoneType.find(params[:id])
  end
  
  def update
    @phone_type = PhoneType.find(params[:id])
    if @phone_type.update_attributes(params[:phone_type])
      redirect_to admin_phone_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @phone_type = PhoneType.find(params[:id])
    @phone_type.destroy
    redirect_to admin_phone_types_url
  end
  
end
