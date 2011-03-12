class UserSession < Authlogic::Session::Base
  consecutive_failed_logins_limit(10)
  failed_login_ban_for(1.hour)
  logged_in_timeout = 1.hour
  remember_me(true)
  remember_me_for(3.months)
  find_by_login_method(:find_by_username_or_email)
  generalize_credentials_error_messages(false)

  # Rails3: patch for authlogic
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

end