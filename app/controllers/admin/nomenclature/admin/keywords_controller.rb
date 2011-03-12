class Admin::KeywordsController < Admin::BaseNomenclatureController
  
  def index
    @keywords = Keyword.includes(:translations).order("keyword_translations.name asc").paginate(:include => :validation_types, :page => params[:page], :per_page => 50)
  end
  
  def show
    @keyword = Keyword.find(params[:id])
  end
  
  def new
    @keyword = Keyword.new
  end
  
  def create
    @keyword = Keyword.new(params[:keyword])
    if @keyword.save
      redirect_to admin_keywords_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @keyword = Keyword.find(params[:id])
  end
  
  def update
    @keyword = Keyword.find(params[:id])
    if @keyword.update_attributes(params[:keyword])
      redirect_to admin_keywords_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @keyword = Keyword.find(params[:id])
    @keyword.destroy
    redirect_to admin_keywords_url
  end
  
end
