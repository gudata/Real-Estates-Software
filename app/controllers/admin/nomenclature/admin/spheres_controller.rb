class Admin::SpheresController < Admin::BaseNomenclatureController
  
  def index
    @spheres = Sphere.all
  end
  
  def show
    @sphere = Sphere.find(params[:id])
  end
  
  def new
    @sphere = Sphere.new
  end
  
  def create
    @sphere = Sphere.new(params[:sphere])
    if @sphere.save
      redirect_to admin_spheres_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @sphere = Sphere.find(params[:id])
  end
  
  def update
    @sphere = Sphere.find(params[:id])
    if @sphere.update_attributes(params[:sphere])
      redirect_to admin_spheres_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @sphere = Sphere.find(params[:id])
    @sphere.destroy
    redirect_to admin_spheres_url
  end
  
end
