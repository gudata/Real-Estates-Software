class Admin::PicturesController < Admin::BaseNomenclatureController
#  load_and_authorize_resource
  
  def index
    @pictures = Picture.all
  end
  
  def show
    @picture = Picture.find(params[:id])
  end
  
  def new
    @picture = Picture.new
  end
  
  def create
    @picture = Picture.new(params[:picture])
    if @picture.save
      redirect_to admin_pictures_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @picture = Picture.find(params[:id])
  end
  
  def update
    @picture = Picture.find(params[:id])
    if @picture.update_attributes(params[:picture])
      redirect_to admin_pictures_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    redirect_to admin_pictures_url
  end
  
end
