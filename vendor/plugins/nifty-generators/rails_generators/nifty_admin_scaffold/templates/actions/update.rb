  def update
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
      redirect_to <%= items_path('url') %>
    else
      render :action => 'edit'
    end
  end
