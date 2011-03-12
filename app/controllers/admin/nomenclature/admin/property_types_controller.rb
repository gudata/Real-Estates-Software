class Admin::PropertyTypesController < Admin::BaseNomenclatureController
  
  def index
    @property_types = PropertyType.all
  end
  
  def show
    @property_type = PropertyType.find(params[:id])
  end
  
  def new
    @property_type = PropertyType.new
    @property_type.active = true
  end
  
  def create
    #    raise params.inspect
    @property_type = PropertyType.new(params[:property_type])
    if @property_type.save
      redirect_to edit_admin_property_type_url(@property_type)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @property_type = PropertyType.find(params[:id], :include => [:keywords])
    keywords = Keyword.all

    position = @property_type.keywords.blank? ? KeywordsPropertyType::INCREMENT : @property_type.keywords_property_types.maximum(:position) 

    active_keywords = @property_type.keywords
    not_active_keywords = keywords - active_keywords
    not_active_keywords.each do |new_property_keyword|
      position += KeywordsPropertyType::INCREMENT
      @property_type.keywords_property_types.build(:keyword_id => new_property_keyword.id, :position => position)
    end
  end
  
  def update    
    @property_type = PropertyType.find(params[:id])
    KeywordsPropertyType.delete_all(:property_type_id => @property_type.id)
#    @property_type.keywords_property_types = []
    if @property_type.update_attributes(params[:property_type])
      redirect_to edit_admin_property_type_url(@property_type)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @property_type = PropertyType.find(params[:id])
    @property_type.destroy
    redirect_to admin_property_types_url
  end
  
end


#property_type[keywords_property_types_attributes][1][keyword_id]
#property_type[keywords_property_types_attributes][1][style]