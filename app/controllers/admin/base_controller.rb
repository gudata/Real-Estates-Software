class Admin::BaseController < ApplicationController
  before_filter :require_user
  layout "admin", :except => [:help]

  before_filter :init_layout
  append_view_path("#{::Rails.root}/app/views/admin/nomenclature")


  protected

  def init_layout
    @layout_search = Contact.search(params[:layout_search])
  end
  
  # Когато искаме да фиксираме дадена релация към твърдо зададен потребител
  def merge_with_nested_attributes model_params, association, hash
    fixed_attributes = model_params["#{association}_attributes"] || []
    
    logger.ap fixed_attributes.inspect
    
    fixed_attributes.each do |key, value|
      if value.keys.include?("id")
        hash.keys.each do |sanitize_key|
          fixed_attributes[key].delete(sanitize_key.to_s)
        end
      else
        fixed_attributes[key] = value.merge(hash)
      end
    end

    
    logger.ap fixed_attributes.inspect
    model_params
  end

end
