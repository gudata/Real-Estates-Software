class Admin::ProjectStagesController < Admin::BaseController
  
  def index
    @project_stages = ProjectStage.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @project_stage = ProjectStage.find(params[:id])
  end
  
  def new
    @project_stage = ProjectStage.new
  end
  
  def create
    @project_stage = ProjectStage.new(params[:project_stage])
    if @project_stage.save
      redirect_to admin_project_stages_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @project_stage = ProjectStage.find(params[:id])
  end
  
  def update
    @project_stage = ProjectStage.find(params[:id])
    if @project_stage.update_attributes(params[:project_stage])
      redirect_to admin_project_stages_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @project_stage = ProjectStage.find(params[:id])
    @project_stage.destroy
    redirect_to admin_project_stages_url
  end
  
end
