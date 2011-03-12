class Admin::OfficesController < Admin::BaseNomenclatureController
  
  def index
    @offices = Office.paginate(:page => params[:page])
  end
  
  def show
    @office = Office.find(params[:id])
  end
  
  def new
    @office = Office.new
    @office.build_address
  end
  
  def create
    @office = Office.new(params[:office])
    if @office.save
      redirect_to admin_offices_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @office = Office.find(params[:id])
  end
  
  def update
    @office = Office.find(params[:id])
    if @office.update_attributes(params[:office])
      redirect_to admin_offices_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @office = Office.find(params[:id])
    @office.destroy
    redirect_to admin_offices_url
  end
  
end
