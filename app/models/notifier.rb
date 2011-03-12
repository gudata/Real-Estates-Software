class Notifier < ActionMailer::Base
  
  def default_url_options(options)
    { :host =>  APP_CONFIG['domain']}
  end

  def password_reset_instructions(user)
    @subject = "Password Reset Instructions"
    @from =  "<noreply@#{APP_CONFIG['domain']}>"
    @recipients = user.email
    @sent_on = Time.now
    @body = {
      :edit_password_reset_url => edit_password_reset_url(user.perishable_token),
      :user => user
    }
  end
end