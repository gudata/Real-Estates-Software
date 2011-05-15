class Admin::ProjectsController < Admin::BaseController


  load_resource :contact, :parent => true
  load_and_authorize_resource :project

  before_filter :belongs_to_contact, :only => [:show, :edit, :update, :destroy]


  #  def restrict_project_access
  #    unless can? :peek_offer_from_contact, @project
  #      flash[:error] = "Нямате права да извършите #{self.action_name} върху проекта"
  #      redirect_to :action => "index"
  #    end
  #  end
  
  def index
    @search  = Project.search(params[:search])
    
    @projects = @search.relation.where(:contact_id => @contact.id)
      

    @projects = @projects.paginate(
      :page => params[:page],
      :per_page => 10
    )
  end

  # Display the projects for a contact
  #  redirect_to admin_contacts_url
  #  #        @projects = current_user.projects_for_contact(@contact).paginate(:page => params[:page],
  #  #      :per_page => @@per_page)
  #  raise "трябва да се види дали не може да се централизира както е в contact.tab_projects"
  #  @search = Project.search(params[:search])
  #  @projects = @search.paginate(:page => params[:page],
  #    :include => [
  #      :translations => [],
  #      :address => [],
  #      :status => []
  #    ]
  #  )


  #  # Display mine projects
  #  def mine
  #    conditions_terms = [{"user_id" => current_user}]
  #
  #    if !params[:search] or params[:search][:status_id_equals]
  #      conditions_terms << {"status.hide_on_this_status" => false}
  #    end
  #
  #    conditions = conditions_terms.map { |c| Project.merge_conditions(c) }.join(' AND ')
  #
  #    @search  = Project.search(params[:search])
  #    @projects = @search.paginate(
  #      #      :include => {:user => [], :contact => []},
  #      :conditions => conditions,
  #      :page => params[:page]
  #    )
  #  end


  # Those bellow require contact id
  def show
    @project = Project.find(params[:id], :include =>{:user => [], :pictures => [], :documents => []})
  end

  # това се вика когато си във контакта и искаш да направиш нов проект 
  def new
    @project = @contact.projects.build
    @project.user = current_user
    @project.status = Status.default_statuses.first
    @project.build_address
  end
  
  def create
    #    assigned_attributes = merge_with_nested_attributes params[:project], :inspections, {:user_id => current_user.id}
    @project = Project.new(params[:project])
    
    if cannot?(:set_owner, @project) || @project.user.blank?
      @project.user = current_user
    end
    
    @project.contact = @contact

    if @project.save
      flash[:message] = "Успешен запис на проект #{@project.name}"
      redirect_to edit_admin_contact_project_url(
        :contact_id => @contact,
        :id => @project,
        :current_tab => params[:current_tab]
      )
    else
      render :action => 'new'
    end
  end
  
  def edit
    #    @project.documents.build
    unless current_user.id == @project.user_id.to_i
      flash[:warning] = t("Редакция като шев", :scope => [:admin])
    end
  end
  
  def update
    unless can? :set_owner, @project
      @project.user = current_user
    end

    assigned_attributes = merge_with_nested_attributes params[:project], :inspections, {:user_id => current_user.id}
    
    if @project.update_attributes(assigned_attributes)
      # && @project.injected_error.blank?
      flash[:message] = "Успешен запис на проект #{@project.name}"
      redirect_to edit_admin_contact_project_path(
        @contact,
        @project,
        :key => @contact.key
      )
    else
      #      @project.errors.add(:document, :invalid, :default  => t("attachment_removed"))
      render :action => 'edit'
    end
  end
  
  def destroy
    @project.destroy
    redirect_to admin_projects_url
  end


  def tab_project_sells
    @project = Project.find(params[:id])
    @sells = @project.sells

    render :action => "tab_project_sells", :layout => false
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