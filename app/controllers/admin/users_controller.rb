class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource

  def index

    params[:search] = {} unless params[:search]
    params[:search][:active_equals] = true unless params[:search][:active_equals]

    @search = User.search(params[:search])

    @users = @search.relation.
      includes(:role => [], :team => [], :office => [:address]).
      order('created_at DESC').
      paginate(:page => params[:page])
  end
  
  def show
  end
  
  def new
    @user = User.new
  end

  def activate
    @user.active = !@user.active
    @user.save
    redirect_to :action => :index, :search => params[:search] 
  end
  
  def create
    @user = User.new(params[:user])

#    @user.parent = current_user

    @user.attributes = params[:user]

    valid_role

    unless @user.errors.empty?
      render :action => 'edit'
      return
    end

    if @user.save
      redirect_to admin_users_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    #    if params[:user][:parent_id] && cannot?(:set_owner, current_user)
    #    params[:user][:parent_id] = current_user.id
    #    end

    @user.attributes = params[:user]
    
    valid_role

    unless @user.errors.empty?
      render :action => 'edit'
      return
    end

    if @user.update_attributes(params[:user])
      redirect_to admin_users_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url
  end


  private
  def edit_self?
    current_user.id != @user.id
  end

  def valid_role
    if current_user.assistant
      if !edit_self?
        @user.parent = current_user.parent
      end
      if current_user.role_id == @user.role_id and @user.id != current_user.id
        @user.errors.add(:assistant, t("Не можете да добавяте потребители с вашата роля", :scope => [:admin, :users]))
      end
    else
      if current_user.role_id == @user.role_id and 
          !@user.assistant and
          current_user.id != @user.id and
          !current_user.root?
        @user.errors.add(:assistant, :invalid, :default  => t("Можете да добавяте само помощници за тази роля", :scope => [:admin, :users]))
      end
    end
  end
  
end
