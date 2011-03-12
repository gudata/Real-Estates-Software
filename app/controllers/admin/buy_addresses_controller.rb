class Admin::BuyAddressesController < Admin::BaseController
  layout "admin_simple"

  load_and_authorize_resource :contact
  load_and_authorize_resource :buy, "buy", :class => Buy
  load_resource :address_document, "address_document", :through => :buy, :class => AddressDocument

  def index
    @address_documents = @buy.address_documents
  end

  def new
    @address_document = AddressDocument.new(
      :buy  => @buy
    )
  end

  def edit
    @address_document = @buy.address_documents.find(params[:id])
  end
  
  def create
    #    raise params[:address_document].inspect
    #    @address_document = @buy.address_documents.build(params[:address_document])
    @address_document = AddressDocument.new(params[:address_document])
    @buy.address_documents << @address_document
    #    raise @buy.address_documents.size.inspect
    if  @address_document.save
      redirect_to admin_contact_buy_buy_addresses_path(
        :contact_id => @contact.id, :buy_id => @buy.id.to_param)
    else
      render :action => 'new'
    end
  end

  def update
    @address_document = @buy.address_documents.find(params[:id])
    if @address_document.update_attributes(params[:address_document])
      flash[:notice] = t("Записано успешно", :scope => [:admin, :buys, :address_document])
      redirect_to edit_admin_contact_buy_buy_address_path(
        :contact_id => @contact.id, :buy_id => @buy.id.to_param, :id => @address_document.id.to_param)
    else
      render :action => 'new'
    end
  end

  def destroy
    @address_document = @buy.address_documents.find(params[:id])
    begin
      @address_document.destroy
      flash[:notice] =  t("Адреса е изтрит", :scope => [:admin, :buys, :address_document])
    rescue
      flash[:notice] =  t("Адреса е бил изтрит", :scope => [:admin, :buys, :address_document])
    end
    redirect_to admin_contact_buy_buy_addresses_path(
      :contact_id => @contact.id, :buy_id => @buy.id.to_param)
  end

  # ---------------------------------------------------------------------------
  #  private
  #  def load
  #    @contact = Contact.find(params[:contact_id])
  #    @buy = Buy.find(params[:buy_id])
  #    @address_document = @buy.address_documents.find(params[:id]) if params[:id] and !params[:id].blank? # buy_address
  #    logger.debug("Loaded custom resources \nbuy: #{@buy.inspect} \naddress_document#{@address_document.inspect}")
  #  end
  
end