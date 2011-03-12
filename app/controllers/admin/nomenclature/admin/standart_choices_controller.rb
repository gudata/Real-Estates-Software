class Admin::StandartChoicesController < Admin::BaseNomenclatureController
  
  def index
    @standart_choices = StandartChoice.all
  end
  
  def show
    @standart_choice = StandartChoice.find(params[:id])
  end
  
  def new
    @standart_choice = StandartChoice.new
  end
  
  def create
    @standart_choice = StandartChoice.new(params[:standart_choice])
    if @standart_choice.save
      redirect_to admin_standart_choices_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @standart_choice = StandartChoice.find(params[:id])
  end
  
  def update
    @standart_choice = StandartChoice.find(params[:id])
    if @standart_choice.update_attributes(params[:standart_choice])
      redirect_to admin_standart_choices_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @standart_choice = StandartChoice.find(params[:id])
    @standart_choice.destroy
    redirect_to admin_standart_choices_url
  end
  
end
