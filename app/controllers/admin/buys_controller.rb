class Admin::BuysController < Admin::BaseController

  load_resource :contact
  load_and_authorize_resource :buy, "buy", :class => Buy # :through => :contact 

  layout :choose_layout
  def choose_layout
    if [:tab_basic_data, :tab_search_results].include? params[:action].to_sym
      false
    else
      "admin"
    end
  end
  
  def index
    per_page = 4
    offset = params[:page] ? ((params[:page].to_i - 1) * per_page) : 0
    @buys = current_user.buys_for_contact(@contact).skip(offset).limit(per_page).paginate
  end

  def show
    
  end
  
  def new
    @offer_type = OfferType.find(params[:offer_type_id])

    next_number = Buy.max(:number) || 0
    
    next_number += 1

    @buy = Buy.new(
      :contact  => @contact,
      :number => next_number,
      :offer_type_id => @offer_type.id,
      :user_id => current_user.id,
      :status => Status.default_statuses.first
    )
  end

  def edit
    unless current_user.id == @buy.user_id.to_i
      flash[:warning] = t("Редакция като шев", :scope => [:admin])
    end
  end

  def create
    next_number = Buy.max(:number) || 0
    next_number += 1

    attributes =  {
      :contact_id  => @contact.id,
      :user_id => current_user.id,
      :team_id => current_user.team_id,
      :number => next_number,
      :created_by_user_id => current_user.id
    }

    (params[:buy] || {}).each_pair do |key, value|
      value = value.to_i if value && key.match(/_id/i)
      attributes[key.to_sym] = value
    end


    @buy = Buy.new(attributes)

    if @buy.save
      redirect_to admin_contact_buy_search_criterias_path(:contact_id => @contact.id, :buy_id => @buy.id)
    else
      render :action => 'new'
    end
  end

  def update
     
    attributes = {
      :contact_id  => @contact.id,
      :user_id => current_user.id,
      :created_by_user_id => current_user.id
    }
    (params[:buy] || {}).each_pair do |key, value|
      value = value.to_i if key.match(/_id/i)
      attributes[key.to_sym] = value
    end

    #    @buy.attachments.each{|attachment| attachment.save}

    attributes["attachments_attributes"] ||= {}
    attributes["attachments_attributes"].each_pair do |key, hash|
      attachment = @buy.attachments.build(hash)
      attachment.save
    end

    if @buy.update_attributes(attributes)
      flash[:notice] = t("Записано успешно", :scope => [:admin, :buys])
      redirect_to edit_admin_contact_buy_path(:contact_id => @contact.id, :id => @buy.id)
    else
      render :action => 'new'
    end
    
  end

  def destroy
    begin
      @buy.destroy
      flash[:notice] = "Deleted"
    rescue
    end
    redirect_to admin_contact_buys_path(:contact_id => @contact.id)
  end

  def buy_search_result
    @matching_sell = MatchingSell.new
    @matching_sell << @buy
  end
  
  def tab_search_results
    buy_search_result
  end

  def tab_documents
  end

  def show_attachments
    render :partial => "attachments_list"
  end

  # ajax request
  def change_buy_status
    sell_id = params[:sell_id]
    buy_status_id = params[:buy_status_id]
    
    if buy_status_id == "no_value"
      @buy.marked_sell_documents.delete(sell_id)
    else
      @buy.marked_sell_documents[sell_id] = buy_status_id
    end
    
    @buy.save
    render :text => t("Статуса сменен", :scope =>[:admin, :buys, :search_criteria])
  rescue
    render :text => "Лоши параметри!"
  end
end

