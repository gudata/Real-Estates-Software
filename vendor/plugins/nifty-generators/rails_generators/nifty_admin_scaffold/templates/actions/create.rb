  def create
    @<%= singular_name %> = <%= class_name %>.new(params[:<%= singular_name %>])
    if @<%= singular_name %>.save
      redirect_to <%= items_path('url') %>
    else
      render :action => 'new'
    end
  end
