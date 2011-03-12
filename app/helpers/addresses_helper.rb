module AddressesHelper

  def address_for(current_address)
    address = {:countries => '', :districts => '', :municiaplities => '', :quarters => ''}
    #    countries = Country.all
    # TODO - да се направи с кеш
    countries = $cache[Country]

    raise "Contact your system administrator for this problem" if countries.nil?
    
    selected_country = current_address.country_id.nil? ? countries.first.id.to_i : current_address.country.id.to_i
    address[:countries] = {:options => countries, :selected => selected_country.to_i}

    districts = $cache["District"].select{|d| d.country_id == selected_country}
    selected_district = current_address.district_id.to_i
    address[:districts] = {:options => districts, :selected => selected_district.to_i}

    municipalities = $cache["Municipality"].select{|m| m.district_id == selected_district}
    selected_municipality = current_address.municipality_id.to_i
    address[:municipalities] = {:options => municipalities, :selected => selected_municipality}

    # TODO: City
    #    cities = $cache["City"].select{|c| c.municipality_id == selected_municipality}
    cities = City.find_all_by_municipality_id(selected_municipality, :include => [:quarters])
    selected_city = current_address.city_id.to_i
    address[:cities] = {:options => cities, :selected => selected_city}

    quarters = $cache["Quarter"].select{|q| q.city_id == selected_city}
    selected_quarter = current_address.quarter_id.to_i
    address[:quarters] = {:options => quarters, :selected => selected_quarter}

    return address
  end

  def show_map(address)
    address = address.to_geo_code
    
    map = GoogleMap::Map.new
    if address.success?
      if address.all.size == 1
        map.markers << GoogleMap::Marker.new(:map => map,
          :icon => GoogleMap::SmallIcon.new(map, 'blue'),
          :lat => address.lat,
          :lng => address.lng,
          :open_infoWindow => true,
          :html => address.to_geocodeable_s + "<br/>lat: #{address.lat} lng: #{address.lng}")
        map.zoom = 15

        map_content = "
              #{map.to_html}
              <div style='width: 800px; height: 400px;'>
                #{map.div}
              </div>"
      else
        addresses = address.all
          
        map_content = ''
        addresses.each_index do |index|
          map_content += link_to_remote addresses[index].to_geocodeable_s,
            :url => { :action => "render_map", :controller => 'admin/addresses', :address => addresses[index].to_geocodeable_s} unless index == 0
        end
      end
      
      content_tag :div, :id => 'map1' do
        map_content
      end
    else
      map_content = 'Адреса не може да бъде намерен на картата !'
    end

  end

  def get_address_from_search search
    
    fields = {
      :address_country_id_equals => :country_id,
      :address_district_id_equals => :district_id,
      :address_municipality_id_equals => :municipality_id,
      :address_city_id_equals => :city_id,
      :address_quarter_id_equals => :quarter_id,
      :address_street_equals => :street,
      :address_number_equals => :number,
    }
    translated_fields = {}
    search.conditions.each do |key, value|
      new_key = fields[key]
      translated_fields[new_key] = value if !value.blank? and key.to_s =~ /address/
    end
    
    Address.new(translated_fields)
  end

  def edit_address(form_builder, address)
    
  end

  def readonly_option readonly_fields, field
    if readonly_fields.include?(field)
      {:readonly => "readonly"}
    else
      {}
    end
  end
  
end