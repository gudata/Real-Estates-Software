class Admin::ContactCategoriesController < Admin::BaseNomenclatureController
  
  def index
    @contact_categories = ContactCategory.all
  end
  
  def show
    @contact_category = ContactCategory.find(params[:id])
  end
  
  def new
    @contact_category = ContactCategory.new
  end
  
  def create
    @contact_category = ContactCategory.new(params[:contact_category])
    if @contact_category.save
      redirect_to admin_contact_categories_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @contact_category = ContactCategory.find(params[:id])
  end
  
  def update
    @contact_category = ContactCategory.find(params[:id])
    if @contact_category.update_attributes(params[:contact_category])
      redirect_to admin_contact_categories_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @contact_category = ContactCategory.find(params[:id])
    @contact_category.destroy
    redirect_to admin_contact_categories_url
  end
  
end
