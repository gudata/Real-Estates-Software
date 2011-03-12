# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #  include ExceptionNotifiable
  #  include ExceptionNotification::Notifiable

  protect_from_forgery

  #  Rails3: fixme
  #  enable the protected method bellow
  #  ExceptionNotification::Notifier.exception_recipients = %w(i.bardarov@gmail.com)
  #  ExceptionNotifier.exception_recipients = %w(i.bardarov@gmail.com)

  #  helper :layout
  helper :all # include all helpers, all the time
  helper :date
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :require_user

  helper_method :current_user_session, :current_user

  def available_locales
    AVAILABLE_LOCALES;
  end

  before_filter :set_locale
  before_filter :set_timezone
  
  def set_timezone
    Time.zone = "Sofia"
    #    if self.logged_in?
    #      # current_user.time_zone #=> 'London'
    #      Time.zone = current_user.time_zone
    #    else
    #      Time.zone = "Stockholm"
    #    end
  end


  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message + "  <span class=\"url\"> #{request.referer}</span>"
    redirect_to user_home_page(current_user, {:permission_error => true})
  end

  protected

  def default_url_options(options={})
    #    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
  
  def set_locale
    I18n.locale = params[:locale]
    I18n.locale = current_user.locale if current_user && !current_user.locale.blank?

    # lets do here the will_paginate configuration to match the current locale.
    # do you have idea where it is better to do this?
    #    WillPaginate::ViewHelpers.pagination_options[:previous_label] = I18n::t('Previous page', :scope=>[:will_paginate])
    #    WillPaginate::ViewHelpers.pagination_options[:next_label] = I18n::t('Next page', :scope=>[:will_paginate])
  end
  
  # избира начална страница в зависимост от потребителят
  def user_home_page user, message={}
    case user.role.to_sym
    when :guest
      return guest_screen_admin_navigations_url
    else
      return root_url(message)
    end
  end
  
  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = t(:"must_be_logged", :scope => :user_sessions)
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = t(:"must_be_not_logged", :scope => :user_sessions)
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri unless request.request_uri == "/"
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  protected
  # Rails 3 exception notification - enable me
  #exception_data :additional_data

  def additional_data
    {
      :current_user => current_user,
    }
  end


end
