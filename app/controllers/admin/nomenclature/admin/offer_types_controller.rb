class Admin::OfferTypesController < Admin::BaseController
  
  def index
    @offer_types = OfferType.paginate(:page => params[:page])
  end
  
  def show
    @offer_type = OfferType.find(params[:id])
  end
  
  def new
    @offer_type = OfferType.new
  end
  
  def create
    @offer_type = OfferType.new(params[:offer_type])
    if @offer_type.save
      redirect_to admin_offer_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @offer_type = OfferType.find(params[:id])
  end
  
  def update
    @offer_type = OfferType.find(params[:id])
    if @offer_type.update_attributes(params[:offer_type])
      redirect_to admin_offer_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @offer_type = OfferType.find(params[:id])
    @offer_type.destroy
    redirect_to admin_offer_types_url
  end
  
end
