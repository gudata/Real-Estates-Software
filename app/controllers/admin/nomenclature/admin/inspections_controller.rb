class Admin::InspectionsController < Admin::BaseNomenclatureController
  
  def index
    @inspections = Inspection.all
  end
  
  def show
    @inspection = Inspection.find(params[:id])
  end
  
  def new
    @inspection = Inspection.new
  end
  
  def create
    @inspection = Inspection.new(params[:inspection])
    if @inspection.save
      redirect_to admin_inspections_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @inspection = Inspection.find(params[:id])
  end
  
  def update
    @inspection = Inspection.find(params[:id])
    if @inspection.update_attributes(params[:inspection])
      redirect_to admin_inspections_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @inspection = Inspection.find(params[:id])
    @inspection.destroy
    redirect_to admin_inspections_url
  end
  
end
