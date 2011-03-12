class Admin::ProjectSellsController < Admin::BaseController

  load_and_authorize_resource :contact, :parent => true
  load_and_authorize_resource :project, :parent => true
  load_and_authorize_resource :sell, "sell", :class => Sell

  layout "admin_simple"

  #  def restrict_project_access
  #    unless can? :peek_offer_from_contact, @project
  #      flash[:error] = "Нямате права да извършите #{self.action_name} върху проекта"
  #      redirect_to :action => "index"
  #    end
  #  end
  
  def index
    per_page = 15
    offset = params[:page] ? ((params[:page].to_i - 1) * per_page) : 0
    @sells = SellDocument.where(:project_id => @project.id).
      order_by([[:updated_at, :desc], [:created_at_at, :desc]]).
      skip(offset).
      limit(per_page).
      paginate
  end

  def new
    @sell = @project.make_sell
    @sell.offer_type_id = $cache["OfferType"].detect{|ot| ot.tag == Contact::TAG_SELLERS}.id
  end
  
  def create
    @sell = @project.make_sell params[:sell]

    if @sell.save
      flash[:simple_message] = "Успешен запис на оферта към #{@project.name}"
      case params[:do_action]
      when "only_save"
        redirect_to admin_contact_project_sells_url(
          :contact_id => @contact.id, :project_id => @project
        )
      when "save_and_continue"
        redirect_to new_admin_contact_project_sell_url(
          :contact_id => @contact.id, :project_id => @project
        )
      when "save_and_duplicate"
        new_sell = @sell.clone
        new_sell.save
        redirect_to edit_admin_contact_project_sell_url(
          :contact_id => @contact.id, 
          :project_id => @project.id,
          :id => new_sell.id
        )
      else
        redirect_to admin_contact_project_sells_url(
          :contact_id => @contact.id, :project_id => @project
        )
      end
    else
      render :action => 'new'
    end
  end
  
  def edit
    #    @project.documents.build
  end
  
  #  def update
  #    unless can? :set_owner, @project
  #      @project.user = current_user
  #    end
  #
  #    assigned_attributes = merge_with_nested_attributes params[:project], :inspections, {:user_id => current_user.id}
  #
  #    if @project.update_attributes(assigned_attributes)
  #      # && @project.injected_error.blank?
  #      flash[:message] = "Успешен запис на проект #{@project.name}"
  #      redirect_to edit_admin_contact_project_path(
  #        @contact,
  #        @project,
  #        :key => @contact.key
  #      )
  #    else
  #      #      @project.errors.add(:document, :invalid, :default  => t("attachment_removed"))
  #      render :action => 'edit'
  #    end
  #  end
  #
  #
  #  def project_sells
  #    @project = Project.find(params[:id])
  #    @sells = @project.sells
  #
  #    render :action => "project_sells", :layout => false
  #  end

end