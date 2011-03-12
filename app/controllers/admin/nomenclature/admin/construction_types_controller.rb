class Admin::ConstructionTypesController < Admin::BaseNomenclatureController
  
  def index
    @construction_types = ConstructionType.all
  end
  
  def show
    @construction_type = ConstructionType.find(params[:id])
  end
  
  def new
    @construction_type = ConstructionType.new
  end
  
  def create
    @construction_type = ConstructionType.new(params[:construction_type])
    if @construction_type.save
      redirect_to admin_construction_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @construction_type = ConstructionType.find(params[:id])
  end
  
  def update
    @construction_type = ConstructionType.find(params[:id])
    if @construction_type.update_attributes(params[:construction_type])
      redirect_to admin_construction_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @construction_type = ConstructionType.find(params[:id])
    @construction_type.destroy
    redirect_to admin_construction_types_url
  end
  
end
