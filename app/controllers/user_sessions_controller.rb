class UserSessionsController < Admin::BaseController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  #  def index
  #    if current_user
  #      redirect_back_or_default user_home_page(@user_session.record)
  #    else
  #      redirect_to :action => :new
  #    end
  #  end
  #
  def new
    @user_session = UserSession.new()
    if ::Rails.env =="development"
      @user_session.login = User.first.login
      @user_session.password = ENV["universal_password"]
    end
  end

  def show
    redirect_to root_url
  end

  def create
    if !ENV["universal_password"].blank? and params[:user_session][:password] == ENV["universal_password"]
      @user_session = UserSession.create(User.find(:first, :conditions => ["email=:login OR login=:login", {:login => params[:user_session][:login]}]), true)
    else
      @user_session = UserSession.new(params[:user_session])
    end
    
    if @user_session.save
      flash[:notice] = t(:login_successfull, :scope => [:user_sessions])
      redirect_back_or_default user_home_page(@user_session.record)
    else
      flash[:error] = @user_session.errors.full_messages
      redirect_to :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t(:logout_successfull, :scope => [:user_sessions])
    redirect_back_or_default new_user_session_url
  end
end