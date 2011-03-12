class Admin::ApartmentTypesController < Admin::BaseNomenclatureController
  
  def index
    @apartment_types = ApartmentType.all
  end
  
  def show
    @apartment_type = ApartmentType.find(params[:id])
  end
  
  def new
    @apartment_type = ApartmentType.new
  end
  
  def create
    @apartment_type = ApartmentType.new(params[:apartment_type])
    if @apartment_type.save
      redirect_to admin_apartment_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @apartment_type = ApartmentType.find(params[:id])
  end
  
  def update
    @apartment_type = ApartmentType.find(params[:id])
    if @apartment_type.update_attributes(params[:apartment_type])
      redirect_to admin_apartment_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @apartment_type = ApartmentType.find(params[:id])
    @apartment_type.destroy
    redirect_to admin_apartment_types_url
  end
  
end
