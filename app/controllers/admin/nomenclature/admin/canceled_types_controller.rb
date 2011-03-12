class Admin::CanceledTypesController < Admin::BaseNomenclatureController

  def index
    @canceled_types = CanceledType.all
  end
  
  def show
    @canceled_type = CanceledType.find(params[:id])
  end
  
  def new
    @canceled_type = CanceledType.new
  end
  
  def create
    @canceled_type = CanceledType.new(params[:canceled_type])
    if @canceled_type.save
      redirect_to admin_canceled_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @canceled_type = CanceledType.find(params[:id])
  end
  
  def update
    @canceled_type = CanceledType.find(params[:id])
    if @canceled_type.update_attributes(params[:canceled_type])
      redirect_to admin_canceled_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @canceled_type = CanceledType.find(params[:id])
    @canceled_type.destroy
    redirect_to admin_canceled_types_url
  end
  
end
