class Admin::BuyStatusesController < Admin::BaseNomenclatureController
#  load_and_authorize_resource
  
  def index
    @buy_statuses = BuyStatus.all
  end
  
  def show
    @buy_status = BuyStatus.find(params[:id])
  end
  
  def new
    @buy_status = BuyStatus.new
  end
  
  def create
    @buy_status = BuyStatus.new(params[:buy_status])
    if @buy_status.save
      redirect_to admin_buy_statuses_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @buy_status = BuyStatus.find(params[:id])
  end
  
  def update
    @buy_status = BuyStatus.find(params[:id])
    if @buy_status.update_attributes(params[:buy_status])
      redirect_to admin_buy_statuses_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @buy_status = BuyStatus.find(params[:id])
    @buy_status.destroy
    redirect_to admin_buy_statuses_url
  end
  
end
