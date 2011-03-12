class Admin::AttachmentsController < Admin::BaseController
  layout "admin_simple"

  load_resource :contact
  load_resource :buy, "buy", :class => Buy
  load_and_authorize_resource :attachment, "attachment", :through => :buy, :class => Attachment

  def index
    @attachments = @buy.attachments
    @attachment = Attachment.new(
      :folder  => @buy,
      :user_id => current_user.id
    )
  end

  def new
    @attachment = Attachment.new(
      :folder  => @buy,
      :user_id => current_user.id
    )
  end

  def edit
    @attachment = @buy.attachments.find(params[:id])
  end
  
  def create
    #    raise params[:address_document].inspect
    #    @attachment = @buy.attachments.build(params[:address_document])
    @attachment = Attachment.new(params[:attachment])
    @attachment.user = current_user
    @buy.attachments << @attachment
    #    raise @buy.attachments.size.inspect
    if  @attachment.save
      redirect_to admin_contact_buy_attachments_path(
        :contact_id => @contact.id, :buy_id => @buy.id.to_param)
    else
      render :action => 'new'
    end
  end

  def update
    @attachment = @buy.attachments.find(params[:id])
    @attachment.user = current_user
    if @attachment.update_attributes(params[:attachment])
      flash[:notice] = t("Записан успешно", :scope => [:admin,  :attachments])
      redirect_to admin_contact_buy_attachments_path(:contact_id => @contact.id, :buy_id => @buy.id.to_param)
    else
      render :action => 'new'
    end
  end

  def destroy
    @attachment = @buy.attachments.find(params[:id])
    begin
      @attachment.destroy
      flash[:notice] =  t("Документа е изтрит", :scope => [:admin, :attachments])
    rescue
      flash[:notice] =  t("Документа е бил изтрит", :scope => [:admin, :attachments])
    end
    redirect_to admin_contact_buy_attachments_path(:contact_id => @contact.id, :buy_id => @buy.id.to_param)
  end

  # ---------------------------------------------------------------------------
  #  private
  #  def load
  #    @contact = Contact.find(params[:contact_id])
  #    @buy = Buy.find(params[:buy_id])
  #    @attachment = @buy.attachments.find(params[:id]) if params[:id] and !params[:id].blank? # buy_address
  #    logger.debug("Loaded custom resources \nbuy: #{@buy.inspect} \naddress_document#{@attachment.inspect}")
  #  end
  
end