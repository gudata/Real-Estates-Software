class Admin::SellsController < Admin::BaseController

  load_resource :contact, :parent => true
  load_and_authorize_resource :sell

  before_filter :belongs_to_contact, :only => [:show, :edit, :update, :destroy] 

  def index
    per_page = 15
    offset = params[:page] ? ((params[:page].to_i - 1) * per_page) : 0
    @sells = current_user.sells_for_contact(@contact).
      order_by([[:updated_at, :desc], [:created_at_at, :desc]]).
      skip(offset).
      limit(per_page).
      paginate
  end

  def show
    @sell = @contact.sells.find(params[:id],
      :include => {
        :property_type => [:keywords => :keywords_property_types],
        :inspections => {:user => []},
      }      
    )
  end
  
  def new
    #      @keywords = Keyword.all(:conditions =>
    #          [
    #          "keywords_property_types.property_type_id=:property_type_id",
    #          {:property_type_id=> params[:property_type_id]}
    #        ],
    #        :include => [:keywords_property_types],
    #        :order => "keywords_property_types.position"
    #      )

    @keywords = Keyword.where([
        "keywords_property_types.property_type_id=:property_type_id",
        {:property_type_id=> params[:property_type_id]}
      ]).includes(:keywords_property_types, :translations).
      order("keywords_property_types.position")
      
    @sell = @contact.sells.build({
        :property_type_id => params[:property_type_id],
        :offer_type_id => params[:offer_type_id].to_i,
        :user_id => current_user.id
      })

    @sell.build_address
      
    @keywords.each do |keyword|
      @sell.keywords_sells.build(
        :keyword => keyword
      )
    end
  end
  
  def create
    @sell = @contact.sells.build(params[:sell])
    if @sell.save      
      #      redirect_to edit_admin_contact_path(:id => @sell.contact.id, :key => @sell.contact.key)
      flash[:notice] = t("Успешно записана", :scope => [:admin, :sells])
      redirect_to edit_admin_contact_sell_path(:id => @sell.id, :key => @sell.contact.key, :contact_id => @sell.contact.id)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @sell = Sell.where(:id => params[:id]).where("keywords_sells.sell_id" => params[:id]).
      includes(:translations => [],
      :keywords_sells => {:keyword => [:validation_types]}, # :translations
      :offer_type => [:translations],
      :status => [:translations],
      :pictures => [:translations],
      :documents => [:translations],
      :inspections => [:translations],
      :property_category_location => [:translations],
      :property_type => [:translations]).
      limit(1).
      first

    @pictures = @sell.pictures

    availble_keywords = Keyword.where("keywords_property_types.property_type_id" => @sell.property_type.id).
      includes(:keywords_property_types, :translations).
      all()
    sell_keywords = @sell.keywords

    unless availble_keywords.count == sell_keywords.count
      missing_keywords = availble_keywords - sell_keywords
      missing_keywords.each do |missing_keyword|
        @sell.keywords_sells.build(
          :keyword => missing_keyword
        )
      end
    end
    
    unless current_user.id == @sell.user_id.to_i
      flash[:warning] = t("Редакция като шев", :scope => [:admin])
    end
    
  end

  def print
    @sell = Sell.find(params[:id])
    render :layout => 'print'
  end
  
  def update
    @sell = @contact.sells.find(params[:id])
    
    if @sell.update_attributes(params[:sell])
      flash[:notice] = t("Успешно записана", :scope => [:admin, :sells])
      redirect_to edit_admin_contact_sell_path(:id => @sell.id, :key => @sell.contact.key, :contact_id => @sell.contact.id)
      #      edit_admin_contact_path(:id => @sell.contact.id, :key => @sell.contact.key)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @sell = @contact.sells.find(params[:id])
    @sell.destroy
    redirect_to admin_sells_url
  end

  private
  #--------------------------------
  def belongs_to_contact
    unless @contact
      flash[:error] = "Can't display sell without contact"
      redirect_to :action => "index"
    end
    unless @contact.key == params[:key] or @contact.key
      flash[:error] = "Нямате ключ за да достъпите офертите на контакта"
    end
  end

end