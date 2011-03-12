class Admin::StatusesController < Admin::BaseNomenclatureController
#  load_and_authorize_resource
  
  def index
    @statuses = Status.all
  end
  
  def show
    @status = Status.find(params[:id])
  end
  
  def new
    @status = Status.new
  end
  
  def create
    @status = Status.new(params[:status])
    if @status.save
      redirect_to admin_statuses_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @status = Status.find(params[:id])
  end
  
  def update
    @status = Status.find(params[:id])
    if @status.update_attributes(params[:status])
      redirect_to admin_statuses_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @status = Status.find(params[:id])
    @status.destroy
    redirect_to admin_statuses_url
  end
  
end
