class Admin::NavigationsController < Admin::BaseController
  load_and_authorize_resource :navigation, "Navigation", :class => Navigation

  def index
    @messages = Alert.new.check
  end
end
