class Admin::SearchCriteriasController < Admin::BaseController
  #before_filter :load_resources

  load_and_authorize_resource :contact, :parent => true
  load_and_authorize_resource :buy, :class => Buy, :parent => true
  #load_and_authorize_resource :search_criteria, :through => :buy


  verify :params => "search_criteria", :only => [:update, :create],
    :add_flash => {:notice => I18n.t("Изберете вид имот", :scope => [:admin, :buys, :search_criteria])},
    :redirect_to => { :action => "new" }

 
  def property_type_keywords
    if @search_criteria.blank?
      @search_criteria = @buy.search_criterias.build params[:search_criteria]
      @search_criteria.user = current_user
    end
    
    property_type_id = params[:search_criteria][:property_type_id]
    @search_criteria.load_terms(property_type_id)

    respond_to do |wants|
      wants.html { render :partial => 'property_type_keywords', :locals => {:search_criteria => @search_criteria}}
    end
  end

  def add_address
    respond_to do |wants|
      wants.html {
        address = @buy.address_documents.empty? ? @contact.address : @buy.address_documents.last
        render :partial => "admin/addresses/address_form", :locals => {:f => address}
      }
    end
  end

  def index
    @search_criterias = @buy.search_criterias
  end

  def criteria_search_result
    @matching_sell = MatchingSell.new
    @search_criteria = @buy.search_criterias.find(params[:id])
    @matching_sell << @search_criteria
    # TODO - is this can be paginated ??
    #per_page = 4
    #offset = params[:page] ? ((params[:page].to_i - 1) * per_page) : 0
    #@matching_sell.paginate
  end

  def edit
    @search_criteria = @buy.search_criterias.find(params[:id])
    @matching_sell = MatchingSell.new
    @matching_sell << @search_criteria
  end

  def new
    @search_criteria = SearchCriteria.new()
    @search_criteria.property_type = PropertyType.first
    @search_criteria.load_terms(@search_criteria.property_type.id)
  end


  def create
    attributes = params[:search_criteria].merge(:user_id => current_user.id)
    @search_criteria = SearchCriteria.new(attributes)
    @search_criteria.fix_id_types
    @buy.search_criterias << @search_criteria
    if @search_criteria.save
      #      raise @buy.search_criterias.inspect
      #      redirect_to admin_contact_buy_search_criterias_path(:contact_id => @contact.id, :buy_id => @buy.id)
      redirect_to :action => :edit, :id => @search_criteria.id.to_param
    else
      render :action => 'new'
    end
  end

  def update
    # TODO: mongoid patch
    @search_criteria = @buy.search_criterias.find params[:id]
    @search_criteria.terms.delete_all
    @search_criteria.terms = []

    terms_attributes = params[:search_criteria].delete(:terms_attributes).values || []
    terms_attributes.each do |term_attributes|
      puts "--------------------\n"
      puts term_attributes.inspect 
      @search_criteria.terms.build(term_attributes)
    end
    
    if @search_criteria.update_attributes(params[:search_criteria])
      #      ap "Терми брой" + @search_criteria.terms.size.to_s
      flash[:notice] = t( "Search criteria updated!", :scope =>[:admin, :buys, :search_criteria])
      redirect_to :action => :edit
    else
      render :action => :edit
    end
  end

  def destroy
    begin
      @search_criteria = @buy.search_criterias.find params[:id]
      @search_criteria.destroy
      flash[:notice] = "Deleted"
    rescue
    end
    redirect_to admin_contact_buy_search_criterias_path(:contact_id => @contact.id, :buy_id => @buy.id)
  end

end

__END__

"SearchCriteria от парамтерите с термите ни е :"
{"property_type_id"=>"1", "terms"=>[{"name"=>"Инфраструктур\320\260", "tag"=>"infrastructure", "id"=>"4c2c85d39ec2251e9f0000de", "as"=>"check_boxes", "keyword_id"=>"28", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"InfrastructureType"}, {"name"=>"Преходе\320\275", "tag"=>"transitional", "id"=>"4c2c85d39ec2251e9f0000d3", "value"=>"", "as"=>"select", "keyword_id"=>"15", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Категори\321\217", "tag"=>"category", "id"=>"4c2c85d39ec2251e9f0000ce", "as"=>"select", "keyword_id"=>"8", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"PropertyCategoryLocation"}, {"name"=>"Обзавеждан\320\265", "tag"=>"furniture", "id"=>"4c2c85d39ec2251e9f0000d4", "as"=>"select", "keyword_id"=>"16", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"Furnish"}, {"name"=>"Конструкци\321\217", "tag"=>"construction", "id"=>"4c2c85d39ec2251e9f0000cf", "as"=>"select", "keyword_id"=>"9", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"ConstructionType"}, {"name"=>"Отоплени\320\265", "tag"=>"heating", "id"=>"4c2c85d39ec2251e9f0000d5", "as"=>"select", "keyword_id"=>"17", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"HeatingType"}, {"name"=>"Ново строителств\320\276", "tag"=>"new_development", "id"=>"4c2c85d39ec2251e9f0000d0", "value"=>"", "as"=>"select", "keyword_id"=>"10", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Асансьо\321\200", "tag"=>"elevator", "id"=>"4c2c85d39ec2251e9f0000d6", "value"=>"", "as"=>"select", "keyword_id"=>"18", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Терас\320\270", "from"=>"", "tag"=>"balconies", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000d1", "as"=>"string", "keyword_id"=>"13", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Телефо\320\275", "tag"=>"phone", "id"=>"4c2c85d39ec2251e9f0000d7", "value"=>"", "as"=>"select", "keyword_id"=>"19", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Кабелн\320\260", "tag"=>"cable_tv", "id"=>"4c2c85d39ec2251e9f0000d8", "value"=>"", "as"=>"select", "keyword_id"=>"20", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Цен\320\260", "from"=>"", "tag"=>"price", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000c8", "as"=>"string", "keyword_id"=>"1", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Интерне\321\202", "tag"=>"internet", "id"=>"4c2c85d39ec2251e9f0000d9", "value"=>"", "as"=>"select", "keyword_id"=>"21", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Пло\321\211", "from"=>"", "tag"=>"area", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000c9", "as"=>"string", "keyword_id"=>"2", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Обезопасе\320\275", "tag"=>"secured", "id"=>"4c2c85d39ec2251e9f0000da", "value"=>"", "as"=>"select", "keyword_id"=>"22", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Ста\320\270", "from"=>"", "tag"=>"rooms", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000ca", "as"=>"string", "keyword_id"=>"5", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Площ на гараж\320\260", "from"=>"", "tag"=>"garage_area", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000dc", "as"=>"string", "keyword_id"=>"25", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Гара\320\266", "tag"=>"garage", "id"=>"4c2c85d39ec2251e9f0000db", "value"=>"", "as"=>"select", "keyword_id"=>"24", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Ета\320\266", "from"=>"", "tag"=>"floor", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000cb", "as"=>"string", "keyword_id"=>"11", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Парко мест\320\276", "tag"=>"parking_seat", "id"=>"4c2c85d39ec2251e9f0000dd", "value"=>"", "as"=>"select", "keyword_id"=>"26", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Разположени\320\265", "tag"=>"exposure", "id"=>"4c2c85d39ec2251e9f0000d2", "as"=>"select", "keyword_id"=>"14", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"ExposureType"}, {"name"=>"Предназначени\320\265", "tag"=>"used_for", "id"=>"4c2c85d39ec2251e9f0000cd", "values"=>["1", "2"], "as"=>"select", "keyword_id"=>"7", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"PropertyFunction"}]}
{"property_type_id"=>"1", "terms"=>[{"name"=>"Цен\320\260", "from"=>"", "tag"=>"price", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000c8", "as"=>"string", "keyword_id"=>"1", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Ново строителств\320\276", "tag"=>"new_development", "id"=>"4c2c85d39ec2251e9f0000d0", "value"=>"", "as"=>"select", "keyword_id"=>"10", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Интерне\321\202", "tag"=>"internet", "id"=>"4c2c85d39ec2251e9f0000d9", "value"=>"", "as"=>"select", "keyword_id"=>"21", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Асансьо\321\200", "tag"=>"elevator", "id"=>"4c2c85d39ec2251e9f0000d6", "value"=>"", "as"=>"select", "keyword_id"=>"18", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Пло\321\211", "from"=>"", "tag"=>"area", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000c9", "as"=>"string", "keyword_id"=>"2", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Терас\320\270", "from"=>"", "tag"=>"balconies", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000d1", "as"=>"string", "keyword_id"=>"13", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Обезопасе\320\275", "tag"=>"secured", "id"=>"4c2c85d39ec2251e9f0000da", "value"=>"", "as"=>"select", "keyword_id"=>"22", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Телефо\320\275", "tag"=>"phone", "id"=>"4c2c85d39ec2251e9f0000d7", "value"=>"", "as"=>"select", "keyword_id"=>"19", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Ста\320\270", "from"=>"", "tag"=>"rooms", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000ca", "as"=>"string", "keyword_id"=>"5", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Площ на гараж\320\260", "from"=>"", "tag"=>"garage_area", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000dc", "as"=>"string", "keyword_id"=>"25", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Инфраструктур\320\260", "tag"=>"infrastructure", "id"=>"4c2c85d39ec2251e9f0000de", "as"=>"check_boxes", "keyword_id"=>"28", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"InfrastructureType"}, {"name"=>"Гара\320\266", "tag"=>"garage", "id"=>"4c2c85d39ec2251e9f0000db", "value"=>"", "as"=>"select", "keyword_id"=>"24", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Преходе\320\275", "tag"=>"transitional", "id"=>"4c2c85d39ec2251e9f0000d3", "value"=>"", "as"=>"select", "keyword_id"=>"15", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Ета\320\266", "from"=>"", "tag"=>"floor", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000cb", "as"=>"string", "keyword_id"=>"11", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Категори\321\217", "tag"=>"category", "id"=>"4c2c85d39ec2251e9f0000ce", "as"=>"select", "keyword_id"=>"8", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"PropertyCategoryLocation"}, {"name"=>"Разположени\320\265", "tag"=>"exposure", "id"=>"4c2c85d39ec2251e9f0000d2", "values"=>["3", "4"], "as"=>"select", "keyword_id"=>"14", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"ExposureType"}, {"name"=>"Парко мест\320\276", "tag"=>"parking_seat", "id"=>"4c2c85d39ec2251e9f0000dd", "value"=>"", "as"=>"select", "keyword_id"=>"26", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Обзавеждан\320\265", "tag"=>"furniture", "id"=>"4c2c85d39ec2251e9f0000d4", "as"=>"select", "keyword_id"=>"16", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"Furnish"}, {"name"=>"Предназначени\320\265", "tag"=>"used_for", "id"=>"4c2c85d39ec2251e9f0000cd", "values"=>["1", "2"], "as"=>"select", "keyword_id"=>"7", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"PropertyFunction"}, {"name"=>"Кабелн\320\260", "tag"=>"cable_tv", "id"=>"4c2c85d39ec2251e9f0000d8", "value"=>"", "as"=>"select", "keyword_id"=>"20", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Конструкци\321\217", "tag"=>"construction", "id"=>"4c2c85d39ec2251e9f0000cf", "as"=>"select", "keyword_id"=>"9", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"ConstructionType"}, {"name"=>"Отоплени\320\265", "tag"=>"heating", "id"=>"4c2c85d39ec2251e9f0000d5", "values"=>["2", "3"], "as"=>"select", "keyword_id"=>"17", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"HeatingType"}]}


params = {"property_type_id"=>"1", "terms"=>[{"name"=>"Цен\320\260", "from"=>"", "tag"=>"price", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000c8", "as"=>"string", "keyword_id"=>"1", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Ново строителств\320\276", "tag"=>"new_development", "id"=>"4c2c85d39ec2251e9f0000d0", "value"=>"", "as"=>"select", "keyword_id"=>"10", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Интерне\321\202", "tag"=>"internet", "id"=>"4c2c85d39ec2251e9f0000d9", "value"=>"", "as"=>"select", "keyword_id"=>"21", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Асансьо\321\200", "tag"=>"elevator", "id"=>"4c2c85d39ec2251e9f0000d6", "value"=>"", "as"=>"select", "keyword_id"=>"18", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Пло\321\211", "from"=>"", "tag"=>"area", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000c9", "as"=>"string", "keyword_id"=>"2", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Терас\320\270", "from"=>"", "tag"=>"balconies", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000d1", "as"=>"string", "keyword_id"=>"13", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Обезопасе\320\275", "tag"=>"secured", "id"=>"4c2c85d39ec2251e9f0000da", "value"=>"", "as"=>"select", "keyword_id"=>"22", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Телефо\320\275", "tag"=>"phone", "id"=>"4c2c85d39ec2251e9f0000d7", "value"=>"", "as"=>"select", "keyword_id"=>"19", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Ста\320\270", "from"=>"", "tag"=>"rooms", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000ca", "as"=>"string", "keyword_id"=>"5", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Площ на гараж\320\260", "from"=>"", "tag"=>"garage_area", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000dc", "as"=>"string", "keyword_id"=>"25", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Инфраструктур\320\260", "tag"=>"infrastructure", "id"=>"4c2c85d39ec2251e9f0000de", "as"=>"check_boxes", "keyword_id"=>"28", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"InfrastructureType"}, {"name"=>"Гара\320\266", "tag"=>"garage", "id"=>"4c2c85d39ec2251e9f0000db", "value"=>"", "as"=>"select", "keyword_id"=>"24", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Преходе\320\275", "tag"=>"transitional", "id"=>"4c2c85d39ec2251e9f0000d3", "value"=>"", "as"=>"select", "keyword_id"=>"15", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Ета\320\266", "from"=>"", "tag"=>"floor", "to"=>"", "id"=>"4c2c85d39ec2251e9f0000cb", "as"=>"string", "keyword_id"=>"11", "kind_of_search"=>"range", "active"=>"", "patern"=>"Integer"}, {"name"=>"Категори\321\217", "tag"=>"category", "id"=>"4c2c85d39ec2251e9f0000ce", "as"=>"select", "keyword_id"=>"8", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"PropertyCategoryLocation"}, {"name"=>"Разположени\320\265", "tag"=>"exposure", "id"=>"4c2c85d39ec2251e9f0000d2", "values"=>["3"], "as"=>"select", "keyword_id"=>"14", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"ExposureType"}, {"name"=>"Парко мест\320\276", "tag"=>"parking_seat", "id"=>"4c2c85d39ec2251e9f0000dd", "value"=>"", "as"=>"select", "keyword_id"=>"26", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Обзавеждан\320\265", "tag"=>"furniture", "id"=>"4c2c85d39ec2251e9f0000d4", "values"=>["3"], "as"=>"select", "keyword_id"=>"16", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"Furnish"}, {"name"=>"Предназначени\320\265", "tag"=>"used_for", "id"=>"4c2c85d39ec2251e9f0000cd", "values"=>["1", "2"], "as"=>"select", "keyword_id"=>"7", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"PropertyFunction"}, {"name"=>"Кабелн\320\260", "tag"=>"cable_tv", "id"=>"4c2c85d39ec2251e9f0000d8", "value"=>"", "as"=>"select", "keyword_id"=>"20", "kind_of_search"=>"exact", "active"=>"", "patern"=>"StandartChoice"}, {"name"=>"Конструкци\321\217", "tag"=>"construction", "id"=>"4c2c85d39ec2251e9f0000cf", "values"=>["2", "3", "4"], "as"=>"select", "keyword_id"=>"9", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"ConstructionType"}, {"name"=>"Отоплени\320\265", "tag"=>"heating", "id"=>"4c2c85d39ec2251e9f0000d5", "values"=>["3", "4"], "as"=>"select", "keyword_id"=>"17", "kind_of_search"=>"multiple", "active"=>"", "patern"=>"HeatingType"}]}

