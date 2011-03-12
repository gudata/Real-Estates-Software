class Admin::ContactsController < Admin::BaseController
  load_and_authorize_resource

  @@per_page = 10
  
  verify :params => "key",
    :only => [:add, :show, :edit, :tab_projects, :tab_buys, :address_form],
    :add_flash => {:notice => "You have to have the key for this contact in order to view it"},
    :redirect_to => { :action => "index" }

  before_filter :check_key,
    :only => [:add, :show, :edit, :destroy, :tab_projects, :tab_offers, :address_form]

  #  def default_url_options(options)
  #    options.merge(:key=> params[:key])
  #  end
  
  def index_contacts
    user_ids = get_visible_user_ids
    
    @search = Contact.search(params[:search])
    #    contacts = Contact.scoped
    #    raise search.relation.to_sql
    @contacts = @search.relation.
      includes(
      :contacts_users => [],
      :phones => [:phone_type],
      :internet_comunicators => [:internet_comunicator_type],
      :translations => []
    ).
      where(
      :contacts_users => {
        :user_id => user_ids, #current_user.id, # за клиент коментирано
        :is_client => false
      }
    ).order("contacts.updated_at DESC")

    @contacts = @contacts.paginate(:page => params[:page], :per_page => Contact.per_page)
  end

  def index_clients
    user_ids = get_visible_user_ids

    @search = Contact.search(params[:search])
    #    raise search.relation.to_sql
    @contacts = @search.relation.
      includes(
#      :sells => [:offer_type],
      :contacts_users => [],
      :translations => []
      #      :users => [],
#      :phones => [:phone_type]
#      :internet_comunicators => [:internet_comunicator_type]
    ). 
      where(
      :contacts_users => {
        :user_id => user_ids,
        :is_client => true
      }
    ).order("contacts.updated_at DESC")

    @contacts = @contacts.paginate(:page => params[:page], :per_page => Contact.per_page)

    @buys_stat = get_buys(user_ids, @contacts)
  end
  
  def show
  end
  
  def new
    @contact = Contact.new(params[:contact])
    @address = @contact.build_address
    
    @phone = @contact.phones.build(:number => params[:phone]) unless params[:phone].blank?
    @phone = @contact.internet_comunicators.build(:value => params[:internet_comunicator]) unless params[:internet_comunicator].blank?
  end
  
  def create
    #    assigned_attributes = merge_with_nested_attributes params[:contact], :projects, {:user_id => current_user.id}

    @contact = Contact.new(params[:contact])

    #    @address = @contact.address
    
    @contact.contacts_spheres = get_spheres(@contact, params[:sphere_ids])
    @contact.contacts_contact_categories = get_categories(@contact, params[:contact_category_ids])
    if @contact.save
      @contact.add_to_users(current_user)
      redirect_to edit_admin_contact_path(
        :id => @contact.id,
        :key => @contact.key,
        :curent_tab => params[:current_tab])
    else
      render :action => "new"
    end
  end
  
  def edit
    @contact = Contact.find_by_id_and_key(params[:id], params[:key],
      :include =>
        {
        :nationality => [],
        :contact_categories => [:contacts_contact_categories],
        :spheres => [],
        :phones => [],
        :internet_comunicators => [],
      }
    )
  end
  
  def update
    @contact.users << current_user unless @contact.users.include?(current_user)
    
    assigned_attributes = merge_with_nested_attributes params[:contact], :projects, {:user_id => current_user.id}
#    assigned_attributes = merge_with_nested_attributes params[:contact], :inspections, {:user_id => current_user.id}
   
    @contact.contacts_spheres = get_spheres(@contact, params[:sphere_ids])
    @contact.contacts_contact_categories = get_categories(@contact, params[:contact_category_ids])
    if @contact.update_attributes(assigned_attributes)
      redirect_to edit_admin_contact_path(
        :id => @contact.id,
        :key => @contact.key,
        :current_tab => params[:current_tab]
      )
    else
      render :action => 'edit'
    end
    
  end


  def add
    unless @contact.users.include?(current_user)
      @contact.add_to_users(current_user)
    end
    redirect_to edit_admin_contact_url(:id => @contact, :key => @contact.key)
  end
  
  def destroy
    was_client = @contact.is_client?
    current_user.remove_contact @contact
    if was_client
      redirect_to index_clients_admin_contacts_url
    else
      redirect_to index_contacts_admin_contacts_url
    end
  end

  def show_offers
    render :partial => "/admin/contacts/offers", :locals => {:contact => @contact}
  end
  
  def check
    params[:search] = params[:layout_search] if params[:layout_search]
    if params[:search]
      user_ids = get_visible_user_ids
      @search  = ContactCheck.new(params[:search])
      error_message, @valid_search = @search.valid_search
      if @valid_search
        @contacts = Contact.scoped
        @contacts = @contacts.includes({
            :phones => [:phone_type],
            :internet_comunicators => [:internet_comunicator_type],
            :address => [:country, :city],
            :nationality => [],
            :users => [],}).joins({}).group("contacts.id")
        @contacts = @search.get_contacts @contacts
        
        @contacts = @contacts.paginate(:page => params[:page])
        @buys_stat = get_buys(user_ids, @contacts)
        
        flash[:error] = t("no_contacts_found", :scope => [:admin, :contacts]) if @contacts.empty?
      else
        flash[:error] = error_message
      end
    end
    
  end

  def tab_contact
    render :action => "tab_contact", :layout => false
  end

  
  def tab_projects
    per_page = 4
    @projects = current_user.projects_for_contact(@contact).paginate(:page => params[:page],
      :per_page => per_page)
    render :action => "tab_projects", :layout => false
  end

  def tab_sells
    per_page = 4
    offset = params[:page] ? ((params[:page].to_i - 1) * per_page) : 0
    @sells = current_user.sells_for_contact(@contact).order_by([[:updated_at, :desc], [:created_at_at, :desc]]).skip(offset).limit(per_page).paginate
    
    render :action => "tab_sells", :layout => false
  end

  def tab_buys
    per_page = 4
    offset = params[:page] ? ((params[:page].to_i - 1) * per_page) : 0
    @buys = current_user.buys_for_contact(@contact).order_by([[:updated_at, :desc], [:created_at_at, :desc]]).skip(offset).limit(per_page).paginate
    render :action => "tab_buys", :layout => false
  end

  private # -------------------------------------------

  def get_visible_user_ids
    user_ids = []
    if current_user.role?(:manager) or current_user.role?(:team_manager)
      current_user.assistant == true ? user_ids = current_user.parent.self_and_descendants.collect(&:id) :
        user_ids = current_user.my_user_ids
    else
      user_ids = current_user.id
    end
    user_ids
  end

  def get_buys user_ids, contacts
    #    buys = Buy.where(:user_id => user.id.to_s, :contact_id.in => [contact_ids])
    flatten_user_ids = []
    flatten_user_ids << user_ids
    flatten_user_ids.flatten!
    contact_ids = contacts.collect{|c| c.id}

    #    raise Buy.only(:contact_id).where(:user_id.in => flatten_user_ids, :contact_id.in => contact_ids).selector.inspect
    hash={};
    Buy.only(:contact_id).where(:user_id.in => flatten_user_ids, :contact_id.in => contact_ids).aggregate.each do |group|
      hash[group["contact_id"].to_i] = group["count"].to_i
    end

    # add entries for fake contacts with ilegal data and email us
    contacts.each do |contact|
      unless hash.key? contact.id
        hash[contact.id] = 0
      end
    end
    hash
  end

  def check_key
    contact = Contact.find_by_id_and_key(params[:id], params[:key])
    unless contact
      flash[:error] = t("Липсва ключ за достъп", :scope => [:admin, :contacts])
      redirect_to :action => :index
      return
    end
  end

  def get_categories contact, contact_category_ids = []
    #    ContactsContactCategory.delete_all("user_id = #{self.id} AND contact_id = #{contact.id}")
    (contact_category_ids || []).collect do |contact_category_id|
      ContactsContactCategory.new(
        :contact_id => contact.id,
        :contact_category_id => contact_category_id,
        :user_id => current_user.id
      )
    end
  end

  def get_spheres contact, sphere_ids = []
    #    ContactsSphere.delete_all("user_id = #{self.id} AND contact_id = #{contact.id}")
    (sphere_ids || []).collect do |sphere_id|
      ContactsSphere.new(
        :contact_id => contact.id,
        :sphere_id => sphere_id,
        :user_id => current_user.id
      )
    end
  end


end


__END__
select * FROM contacts LEFT OUTER JOIN contacts_users ON contacts_users.contact_id = contacts.id LEFT OUTER JOIN internet_comunicators ON internet_comunicators.contact_id = contacts.id LEFT OUTER JOIN countries ON countries.id = contacts.nationality_id LEFT OUTER JOIN country_translations ON country_translations.country_id = countries.id LEFT OUTER JOIN phones ON phones.contact_id = contacts.id LEFT OUTER JOIN contacts_users users_contacts_join ON contacts.id = users_contacts_join.contact_id LEFT OUTER JOIN users ON users.id = users_contacts_join.user_id WHERE (users.id = 1) AND (contacts_users.user_id = 1) AND (contacts_users.is_client = 1) AND (contacts.id IN (94, 2, 3, 4)) ORDER BY contacts.updated_at DESC

SELECT contacts.* FROM contacts
INNER JOIN sells ON sells.client_id = contacts.id
INNER JOIN offer_types ON offer_types.id = sells.offer_type_id
INNER JOIN users ON users.id = contacts_users.user_id
INNER JOIN contacts_users ON contacts.id = contacts_users.contact_id
INNER JOIN phones ON phones.contact_id = contacts.id
WHERE (phones.number LIKE '%2134213%') AND (users.id = 1)
AND (contacts_users.user_id = 1) AND (contacts_users.is_client = 1)


INNER JOIN contacts_users contacts_users_users ON contacts_users_users.user_id = users.id


SELECT `contacts`.* FROM `contacts`

INNER JOIN `sells` ON `sells`.`client_id` = `contacts`.`id` INNER JOIN `offer_types` ON `offer_types`.`id` = `sells`.`offer_type_id` INNER JOIN `contacts_users` ON `contacts`.`id` = `contacts_users`.`contact_id` INNER JOIN `users` ON `users`.`id` = `contacts_users`.`user_id` INNER JOIN `contacts_users` `contacts_users_users` ON `contacts_users_users`.`user_id` = `users`.`id` WHERE (`users`.`id` = 1) AND (`contacts_users`.`user_id` = 1) AND (`contacts_users`.`is_client` = 1) ORDER BY contacts.updated_at DESC LIMIT 0, 9
  SQL (1.1ms)  SELECT COUNT(*) AS count_id FROM `contacts` INNER JOIN `sells` ON `sells`.`client_id` = `contacts`.`id` INNER JOIN `offer_types` ON `offer_types`.`id` = `sells`.`offer_type_id` INNER JOIN `contacts_users` ON `contacts`.`id` = `contacts_users`.`contact_id` INNER JOIN `users` ON `users`.`id` = `contacts_users`.`user_id` INNER JOIN `contacts_users` `contacts_users_users` ON `contacts_users_users`.`user_id` = `users`.`id` WHERE (`users`.`id` = 1) AND (`contacts_users`.`user_id` = 1) AND (`contacts_users`.`is_client` = 1)