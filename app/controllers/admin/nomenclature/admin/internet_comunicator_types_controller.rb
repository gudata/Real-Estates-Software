class Admin::InternetComunicatorTypesController < Admin::BaseNomenclatureController
  
  def index
    @internet_comunicator_types = InternetComunicatorType.all
  end
  
  def show
    @internet_comunicator_type = InternetComunicatorType.find(params[:id])
  end
  
  def new
    @internet_comunicator_type = InternetComunicatorType.new
  end
  
  def create
    @internet_comunicator_type = InternetComunicatorType.new(params[:internet_comunicator_type])
    if @internet_comunicator_type.save
      redirect_to admin_internet_comunicator_types_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @internet_comunicator_type = InternetComunicatorType.find(params[:id])
  end
  
  def update
    @internet_comunicator_type = InternetComunicatorType.find(params[:id])
    if @internet_comunicator_type.update_attributes(params[:internet_comunicator_type])
      redirect_to admin_internet_comunicator_types_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @internet_comunicator_type = InternetComunicatorType.find(params[:id])
    @internet_comunicator_type.destroy
    redirect_to admin_internet_comunicator_types_url
  end
  
end
