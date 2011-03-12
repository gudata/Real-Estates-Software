class Admin::CountriesController < Admin::BaseNomenclatureController
  def index
    @countries = Country.all
  end
  
  def show
    @country = Country.find(params[:id])
  end
  
  def new
    @country = Country.new
  end
  
  def create
    @country = Country.new(params[:country])
    if @country.save
      flash[:notice] = "Successfully created country."
      redirect_to [:admin, @country]
    else
      render :action => 'new'
    end
  end
  
  def edit
    @country = Country.find(params[:id])
  end
  
  def update
    @country = Country.find(params[:id])
    if @country.update_attributes(params[:country])
      flash[:notice] = "Successfully updated country."
      redirect_to [:admin, @country]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @country = Country.find(params[:id])
    @country.destroy
    flash[:notice] = "Successfully destroyed country."
    redirect_to admin_countries_url
  end
end
