class Admin::PhonesController < Admin::BaseNomenclatureController
  
  def index
    @phones = Phone.all
  end
  
  def show
    @phone = Phone.find(params[:id])
  end
  
  def new
    @phone = Phone.new
  end
  
  def create
    @phone = Phone.new(params[:phone])
    if @phone.save
      redirect_to admin_phones_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @phone = Phone.find(params[:id])
  end
  
  def update
    @phone = Phone.find(params[:id])
    if @phone.update_attributes(params[:phone])
      redirect_to admin_phones_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @phone = Phone.find(params[:id])
    @phone.destroy
    redirect_to admin_phones_url
  end
  
end
