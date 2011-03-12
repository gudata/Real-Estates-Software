class Admin::StatisticsController < Admin::BaseController
  #  load_and_authorize_resource :navigation, "Navigation", :class => Navigation

  def index
  end

  def offers_by_team
    @search  = Team.search(params[:search])
    @teams = @search.all
  end

  def do_offers_by_team
    if params[:team_ids].blank?
      @teams = Team.all
    else
      @teams = Team.where(:id => params[:team_ids])
    end
    
    @from = Time.parse(params[:from_date]).change(:hour => 0, :min => 0, :sec => 1) unless params[:from_date].blank?
    @to = Time.parse(params[:to_date]).change(:hour => 23, :min => 59, :sec => 59) unless params[:to_date].blank?
  end
  
  def full_report
    @search  = Team.search(params[:search])
    @teams = @search.all
  end

  def do_full_report
    if params[:team_ids].blank?
      @teams = Team.all
    else
      @teams = Team.where(:id => params[:team_ids])
    end

    @from = Time.parse(params[:from_date]).change(:hour => 0, :min => 0, :sec => 1) unless params[:from_date].blank?
    @to = Time.parse(params[:to_date]).change(:hour => 23, :min => 59, :sec => 59) unless params[:to_date].blank?

    @teams_data = {}
    @statuses = Status.all
    
    @teams.each do |team|
      @teams_data[team] = {}
      Rails.logger.debug("Working on team #{team.id} - #{team.name}")
      team.users.each do |user|
#      [User.find(5), User.find(6)].each do |user|
        next unless user.active
        Rails.logger.debug("  For user #{user.id} #{user.email}")
        @teams_data[team][user] = {}
        @teams_data[team][user][:projects] = {}

        @teams_data[team][user][:buyers] = {}
        @teams_data[team][user][:renters] = {}
        @teams_data[team][user][:sellers] = {}
        @teams_data[team][user][:letters] = {}
        
        @statuses.each do |status|
          Rails.logger.debug("    Status #{status.id} #{status.name}")
          user_statistic = UserStatistic.new(user)
          @teams_data[team][user][:projects][status] = user_statistic.count_projects(user, status, @from, @to)

          @teams_data[team][user][:sellers][status] = user_statistic.count_sellers(user, status, @from, @to)
          @teams_data[team][user][:letters][status] = user_statistic.count_letters(user, status, @from, @to)
          
          @teams_data[team][user][:buyers][status] = user_statistic.count_buyers(user, status, @from, @to)
          @teams_data[team][user][:renters][status] = user_statistic.count_renters(user, status, @from, @to)
        end
      end
    end
    
    #    ap @teams_data

  end



  helper_method :add_time_frame_ar
  def add_time_frame_ar object, from, to
    UserStatistic.add_time_frame_ar object, from, to
  end
  
  helper_method :add_time_frame
  def add_time_frame object, from, to
    UserStatistic.add_time_frame object, from, to
  end


end

__END__

@from = 1.month.ago 
@to = Time.now 

@teams = [Team.first]
teams = {}
statuses = Status.all
