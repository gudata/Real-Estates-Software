class Admin::BaseNomenclatureController < Admin::BaseController
#  load_and_authorize_resourcee

  before_filter :restrict_project_access
  after_filter :clean_cache, :only => [:create, :update, :destroy]

  def clean_cache
    logger.debug("Reseting the cache !")
    $cache = Cache.new
  end
  
  def restrict_project_access
    unless can? :nomenclature, Navigation.new
      flash[:error] = "Нямате права да извършите #{self.action_name} върху проекта"
      redirect_to root_url
    end
  end
end
