require 'will_paginate/array'

class Admin::Indexes::SellsController < Admin::IndexesController

  load_and_authorize_resource :sell, "sell", :class => Sell

  @@per_page = 5

  #  load_and_authorize_resource
  def default_url_options(options={})
    options.merge(:offer_type_id => params[:offer_type_id])
  end 

  def index
    @sells = get_sells
  end

  def user_offers
    @sells = get_sells :user_id => current_user.id
    
    render :action => "index"
  end

  private
  def get_sells init_params={}
    if params[:commit]
      if params[:sell_search]
        # параметрите от търсенето са значещи
        if params[:sell_search][:number].blank?
          search_params =  params[:sell_search]
        else
          search_params = {}
          search_params[:number] = params[:sell_search][:number]
        end
      else
        # взимаме параметрите по-подразбиране за търсенето
        search_params = init_params
        search_params[:status_ids] = Status.active.all.collect{|s| s.id}
      end

      @sell_search = SellSearch.new(search_params)

      if !search_params[:status_ids].blank? and !search_params[:number].blank?
        flash[:notice] = t("number_or_status_warning", :scope => [:admin, :sell_search])
      end

      per_page = params[:per_page] ? params[:per_page].to_i : @@per_page
      offset = params[:page] ? ((params[:page].to_i - 1) * per_page) : 0


      @sells = @sell_search.sell_documents.paginate(:page => params[:page], :per_page => params[:per_page])
    else
      @sell_search = SellSearch.new(:offer_type_id => params[:offer_type_id])
      @sells = []
    end

  end

end