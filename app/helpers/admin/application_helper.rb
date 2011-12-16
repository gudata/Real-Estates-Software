module Admin::ApplicationHelper
  
  def show_phones(phones, style = "display: block")
    if phones.size > 1
      phone_list = phones.collect{|phone| "#{phone.phone_type.name}: #{phone.number};"} rescue ''
      content_tag :ul, {}, false do
        phone_list.collect{|phone| content_tag(:li, phone)}.join('').html_safe
      end
    else
      content_tag :div, {:style => style}, false do
        "#{phones.first.phone_type.name}: #{phones.first.number}" rescue ''
      end
    end
  end

  def show_comunicators(internet_comunicators, style = "display: block")
    if internet_comunicators.size > 1
      comunicator_list = internet_comunicators.collect do |comunicator|
        "#{comunicator.internet_comunicator_type.name}: #{comunicator.value};" rescue ''
      end
      content_tag :ul do
        comunicator_list.collect{|comunicator| content_tag(:li, comunicator)}.join('').html_safe rescue ''
      end
    else
      content_tag :div, :style => style do
        "#{internet_comunicators.first.internet_comunicator_type.name}: #{internet_comunicators.first.value}" rescue ''
      end
    end
  end

  
  def breadcrumbs_for_contact(*objects)
    #    raise objects.inspect
    classes = {
      "Contact" => lambda do |*args|
        contact = args.first
        link_to(contact.name, edit_admin_contact_url(:id => contact.id, :key => contact.key))
      end,
      :contact_buys_index => lambda do |*args|
        contact = args.first
        link_to(t("Оферти търси", :scope => [:admin, :buys]), admin_contact_buys_url(contact))
      end,
      :contact_sells_index => lambda do |*args|
        contact = args.first
        link_to(t("Оферти предлага", :scope => [:admin, :sells]), admin_contact_sells_url(contact))
      end,
      :contact_projects_index => lambda do |*args|
        contact = args.first
        link_to(t("Проекти предлага", :scope => [:admin, :project]), admin_contact_projects_url(contact))
      end,
      "Project" => lambda do |*args|
        contact, contact_projects_index, project = args
        project = project.first if project.class == Array
        if project.new_record?
          t("Нов проект", :scope => [:admin, :project], :number => project.name)
        else
          link_to(t("Редакция проект в кръмбовете", :scope => [:admin, :project], :number => project.name), edit_admin_contact_project_url(contact, project))
        end
      end,
      "Buy" => lambda do |*args|
        contact, buy_index, buy = args
        if buy.new_record?
          t("Нова оферта", :scope => [:admin, :buys], :number => buy.number)
        else
          link_to(t("Оферта номер", :scope => [:admin, :buys], :number => buy.number, :kind => buy.offer_type.name),
                  edit_admin_contact_buy_url(contact, buy)
          )
        end
      end,
      "Sell" => lambda do |*args|
        contact, sell_index, project, sell = args
        sell = project if sell.nil?

        if sell.new_record?
          t("Нова оферта продава", :scope => [:admin, :sells], :number => sell.number)
        else
          link_to(t("Оферта номер", :scope => [:admin, :sells], :number => sell.number, :kind_of => sell.offer_type.name),
            edit_admin_contact_sell_path(
              :contact_id => contact,
              :id => sell.id,
              :key => contact.key
            ))
        end
      end,
      :search_criteria_index => lambda do |*args|
        contact, buys_index, buy, search_criteria_index = args
        link_to( t("Списък с критерии", :scope => [:admin, :buys, :search_criteria]),
                 admin_contact_buy_search_criterias_url( :buy_id => buy.id.to_s,
                                                         :contact_id => contact.id
                 )
        )
      end,
      "SearchCriteria" => lambda do |*args|
        contact, buys_index, buy, search_criteria_index, search_criteria = args
        if search_criteria.new_record?
          t("Нов критерий", :scope => [:admin, :buys, :search_criteria], :number => buy.number)
        else
          link_to(t("Критерий", :scope => [:admin, :buys, :search_criteria]),
                  edit_admin_contact_buy_search_criteria_url(:contact_id => contact.id,
                                                             :buy_id => buy.id.to_s,
                                                             :search_criteria_id => search_criteria.id
                  )
          )
        end
      end,
      "MatchingSell" => lambda do |*args|
        contact, buys_index, buy, search_criteria_index, matching_sell = args

        link_to( t("Съвпадащи резултати", :scope => [:admin, :buys, :search_criteria, :search_result]),
                 criteria_search_result_admin_contact_buy_search_criteria_path( :contact_id => @contact.id,
                                                                                :buy_id => @buy.id.to_s,
                                                                                :id => matching_sell.presentation_object
                 )
        )
      end,
    }

    separator = '&rarr;' # nice ->
    message = "#{separator} " +
      objects.collect { |object|
      key = (object.class == Symbol) ? object : object.class.to_s
      classes[key].call(*objects)
    }.flatten.join(" #{separator} ")
    message = message.html_safe

    content_tag :div, message, :class => "ui-helper-clearfix ui-widget-header ui-corner-all breadcrumb "
  end


  def humanize_buy_or_criteria object
    text = case object
    when Buy
      contact = object.contact
      object.search_criterias.collect do |search_criteria|
        content_tag(:span, link_to(search_criteria.property_type.name, edit_admin_contact_buy_search_criteria_path(:contact_id => contact.id, :buy_id => object.id.to_param, :id => search_criteria.id.to_param)) +
            " " +
            search_criteria.filled_terms.size.to_s +
            " ",
          :class =>"criteria")
      end
    when SearchCriteria
      contact = object.buy.contact
      ["<span class=\"criteria\">#{link_to(object.property_type.name, edit_admin_contact_buy_search_criteria_path(contact, object.buy, object))} #{object.filled_terms.size}</span> "]
    end

    text 
  end

  def show_address(address, format = :short)
    #    raise address.inspect
    country =  $cache[Country].detect(Proc.new{false}){|country_tmp| country_tmp.id == address.country_id}
    if country
      if country.icon.url
        country_tag = content_tag(:span, image_tag(country.icon.url), :class => "c_flag", :title => country.name) + 
          content_tag(:span, country.name, :class => "c_name_print")
      else 
        country_tag = content_tag(:span, country.name, :class => "c_name")
      end

    end

    district = $cache[District].detect(Proc.new{false}){|district_tmp| district_tmp.id == address.district_id}
    district_name = district.name unless district == false

    municipality = $cache[Municipality].detect(Proc.new{false}){|municipality_tmp| municipality_tmp.id == address.municipality_id}
    municipality_name = municipality.name unless municipality == false

    # TODO: City
    #    city = $cache[City].detect(Proc.new{false}){|city| city.id == address.city_id.to_s}
    city = City.find_by_id(address.city_id)
    if city
      city_place_type = city.place_type
      city_name = city.name
    else
      city_place_type = nil
      city_name = nil
    end

    quarter = $cache[Quarter].detect(Proc.new{false}){|quarter_cache| quarter_cache.id == address.quarter_id}
    quarter_name = quarter.name unless quarter == false

    case format
    when :short
      content_tag :span, :class => 'show_address' do
        [country_tag, city_place_type, city_name, quarter_name].compact.join(" ").html_safe
      end
    when :long
      content_tag :span, :class => 'show_address' do
        a = [
          country_tag,
          minicipality_or_district(district_name, municipality_name),
          city_place_type,
          city_name,
          quarter_name,
          address.street,
          address.building,
        ]
        a << "#{Address.human_attribute_name("number")} #{address.number}" unless address.number.blank?
        a.flatten.compact.join(" ").html_safe
      end
    when *[:sell_info, :buy_info]
      content_tag :span, :class => 'show_address' do
        a = [
          country_tag,
          city_place_type,
          city_name,
          quarter_name,
          address.street,
          address.building,
        ]
        a << "#{Address.human_attribute_name("number")} #{address.number}" unless address.number.blank?
        a << "#{Address.human_attribute_name("floor")}  #{address.floor}" unless address.floor.blank?
        a << "#{Address.human_attribute_name("apartment")} #{address.apartment}" unless address.apartment.blank?
        a << "#{Address.human_attribute_name("entrance")} #{address.entrance}" unless address.entrance.blank?
        a << "#{Address.human_attribute_name("municipality_id")} #{minicipality_or_district(district_name, municipality_name).join(' ')}"
        a.flatten.compact.join(" ").html_safe
      end
    when :full_array
      # not html safe!!!
      content_tag :span, :class => 'show_address' do
        a = [
          country_tag,
          "#{Address.human_attribute_name("district_id")} #{district_name}",
          "#{Address.human_attribute_name("municipality_id")} #{municipality_name}",
          "#{city_place_type} #{city_name}",
          quarter_name,
          "#{address.street} #{address.building}",
        ]
        a << "#{Address.human_attribute_name("number")} #{address.number}" unless address.number.blank?
        a << "#{Address.human_attribute_name("floor")}  #{address.floor}" unless address.floor.blank?
        a << "#{Address.human_attribute_name("apartment")} #{address.apartment}" unless address.apartment.blank?
        a << "#{Address.human_attribute_name("entrance")} #{address.entrance}" unless address.entrance.blank?
        
        return a.flatten.compact
      end
    when :till_street
      content_tag :span, :class => 'show_address' do
        a = [
          country_tag,
          minicipality_or_district(district_name, municipality_name),
          "#{city_place_type} #{city_name}",
          quarter_name,
        ]
        a << address.street unless address.street.blank?
        a.flatten.compact.join(" ").html_safe
      end
    else
      content_tag :span, :class => 'show_address' do
        [country_tag, city_place_type, city_name, quarter_name].compact.join(", ").html_safe
      end
    end
  end

  def minicipality_or_district minicipality, district
    if minicipality == district
      [minicipality]
    else
      [district, minicipality]
    end
  end

end