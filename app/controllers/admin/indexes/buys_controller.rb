require 'will_paginate/array'

class Admin::Indexes::BuysController < Admin::IndexesController

  load_and_authorize_resource :buy, "buy", :class => Buy

  @@per_page = 5
  
  #  load_and_authorize_resource
  def default_url_options(options={})
    options.merge(:offer_type_id => params[:offer_type_id])
  end

  def index
    @buys = get_buys
  end

  def user_offers
    @buys = get_buys :user_id => current_user.id
    render :action => "index"
  end

  private
  def get_buys init_params={}
    if params[:buy_search]
      # параметрите от търсенето са значещи
      search_params =  params[:buy_search]
    else
      # взимаме параметрите по-подразбиране за търсенето
      search_params = init_params
      search_params[:status_ids] = Status.active.all.collect{|s| s.id}
      search_params[:offer_type_id] = params[:offer_type_id]
    end

    @buy_search = BuySearch.new(search_params)

    if !search_params[:status_ids].blank? and !search_params[:number].blank?
      flash[:notice] = t("number_or_status_warning", :scope => [:admin, :buy_search])
    end

    per_page = params[:per_page] ? params[:per_page].to_i : @@per_page
    offset = params[:page] ? ((params[:page].to_i - 1) * per_page) : 0
    if params[:commit]
      puts "selector"
      ap(@buy_search.buy_documents.selector)
      ap(@buy_search.buy_documents.options)
      @buys = @buy_search.buy_documents.skip(offset).limit(per_page).paginate
    else
      @buys = [].paginate
    end
    
    @buys
  end
end