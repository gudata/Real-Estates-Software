class Admin::FurnishesController < Admin::BaseNomenclatureController
#  load_and_authorize_resource
  
  def index
    @furnishes = Furnish.all
  end
  
  def show
    @furnish = Furnish.find(params[:id])
  end
  
  def new
    @furnish = Furnish.new
  end
  
  def create
    @furnish = Furnish.new(params[:furnish])
    if @furnish.save
      redirect_to admin_furnishes_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @furnish = Furnish.find(params[:id])
  end
  
  def update
    @furnish = Furnish.find(params[:id])
    if @furnish.update_attributes(params[:furnish])
      redirect_to admin_furnishes_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @furnish = Furnish.find(params[:id])
    @furnish.destroy
    redirect_to admin_furnishes_url
  end
  
end
