class UsersController < Admin::BaseController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  
  def new
    @user = User.new
#    @person = @user.person.build
  end

  def create
    @user = User.new(params[:user])
    @user.role = Role.get :guest
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = t("Account updated", :scope => [:users])
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end