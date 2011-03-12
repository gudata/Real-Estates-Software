class Admin::Indexes::ProjectSellsController < Admin::IndexesController

  load_resource :project, :parent => true

  def index
    per_page = 2
    offset = params[:page] ? ((params[:page].to_i - 1) * per_page) : 0
    @sells = SellDocument.where(:project_id => @project.id).skip(offset).limit(per_page).paginate
  end

end