class Admin::SourcesController < Admin::BaseNomenclatureController
#  load_and_authorize_resource
  
  def index
    @sources = Source.all
  end
  
  def show
    @source = Source.find(params[:id])
  end
  
  def new
    @source = Source.new
  end
  
  def create
    @source = Source.new(params[:source])
    if @source.save
      redirect_to admin_sources_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @source = Source.find(params[:id])
  end
  
  def update
    @source = Source.find(params[:id])
    if @source.update_attributes(params[:source])
      redirect_to admin_sources_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @source = Source.find(params[:id])
    @source.destroy
    redirect_to admin_sources_url
  end
  
end
