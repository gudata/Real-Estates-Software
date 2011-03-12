class Admin::TeamsController < Admin::BaseNomenclatureController
  
  def index
    @teams = Team.paginate(:page => params[:page])
  end
  
  def show
    @team = Team.find(params[:id])
  end
  
  def new
    @team = Team.new
  end
  
  def create
    @team = Team.new(params[:team])
    if @team.save
      redirect_to admin_teams_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @team = Team.find(params[:id])
  end
  
  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      redirect_to admin_teams_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to admin_teams_url
  end

  def update_team_users
    respond_to do |format|
      format.js {
        @users = User.find_all_by_team_id(params[:team_id])
        render :partial => "/shared/update_team_users"
      }
    end

  end
  
end
