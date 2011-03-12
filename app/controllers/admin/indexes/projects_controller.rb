class Admin::Indexes::ProjectsController < Admin::IndexesController

  load_and_authorize_resource :project, "project"

  before_filter :set_defaults

  def set_defaults
    params[:search] ||= {}
    params[:search][:active_equals] ||= "1"
    params[:search][:status_id_in] ||= Status.active.all.collect{|s| s.id}
  end
  private :set_defaults
  
  def index
    do_search
  end

  def user_projects
    
    params[:search][:user_id_equals] ||= current_user.id
   
    do_search 
    render :action => "index"
  end

  private
  def do_search conditions={}

    #    if params[:search][:status_id_equals]
    @search  = Project.search(params[:search])

    @projects = @search.relation.includes(Project::DEFAULT_INCLUDES)
    per_page = params[:per_page] ? params[:per_page].to_i : Project.per_page
    
    @projects = @projects.paginate(:page => params[:page],  :per_page => per_page )
  end

end