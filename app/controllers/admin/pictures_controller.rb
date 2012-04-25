class Admin::PicturesController < Admin::BaseController
  layout :set_layout

  def index
    @sell = Sell.includes(:contact).find params[:sell_id]
    @pictures = @sell.pictures
    @new_picture = nil
    @updated_picture = nil

    if params[:new_picture_id].present?
      @new_picture = Picture.find params[:new_picture_id]
    end

    if params[:updated_picture_id].present?
      @updated_picture = Picture.find params[:updated_picture_id]
    end
  end

  def new
    @contact = Contact.find params[:contact_id]
    @sell    = Sell.find params[:sell_id]
    @picture = @sell.pictures.new
  end

  def create
    @sell = Sell.includes(:contact).find params[:sell_id]
    @picture = Picture.new(params[:picture])
    @sell.pictures << @picture
    if @sell.save
      @pictures =  @sell.pictures
      redirect_to :action => :index, :new_picture_id => @picture.id
    else
      render :action => :new,
             :contact_id => @contact.id,
             :sell_id => @sell.id
    end
  end

  def edit
    @contact = Contact.find params[:contact_id]
    @sell    = Sell.find params[:sell_id]
    @picture = @sell.pictures.find params[:id]
  end

  def update
    @sell = Sell.find params[:sell_id]
    @picture = @sell.pictures.find params[:id]
    if @picture.update_attributes(params[:picture])
      @pictures =  @sell.pictures
      redirect_to :action => :index, :updated_picture_id => @picture.id and return
    else
      render :action => :edit,
             :contact_id => @contact.id,
             :sell_id => @sell.id
    end
  end

  def show

  end

  def destroy
    @picture = Picture.find params[:id]
    @picture.destroy    
  end
  
  private
  
  def set_layout
    if action_name == 'index'
      'admin_simple'
    else
      false
    end
  end
  
end
