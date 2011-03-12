# defaults to exception.notifier@default.com
#ExceptionNotifier.sender_address = %("Application Error" <i.bardarov@psspy.se>)

# defaults to "[ERROR] "
#ExceptionNotifier.email_prefix = "[re.gudasoft.com] "

Re::Application.config.middleware.use "::ExceptionNotifier",
  :email_prefix => "-- REA ",
  :sender_address => %{"Re" <notifier@re.gudasoft.com>},
  :exception_recipients => %w{i.bardarov@gmail.com}