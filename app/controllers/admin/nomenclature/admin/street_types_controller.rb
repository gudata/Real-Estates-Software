class Admin::StreetTypesController < Admin::BaseNomenclatureController
  
  def index
    @street_types = StreetType.all
  end
  
  def show
    @street_type = StreetType.find(params[:id])
  end
  
  def new
    @street_type = StreetType.new
  end
  
  def create
    @street_type = StreetType.new(params[:street_type])
    if @street_type.save
      redirect_to admin_street_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @street_type = StreetType.find(params[:id])
  end
  
  def update
    @street_type = StreetType.find(params[:id])
    if @street_type.update_attributes(params[:street_type])
      redirect_to admin_street_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @street_type = StreetType.find(params[:id])
    @street_type.destroy
    redirect_to admin_street_types_url
  end
  
end
