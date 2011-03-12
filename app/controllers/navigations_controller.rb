class NavigationsController < ApplicationController
  
  def quarters
    @quarters = Quarter.where( {:city_id => params[:city_id]}).order("quarter_translations.name asc")
    
    respond_to do |format|
      format.html {render :partial => "quarters", :locals => {:quarters => @quarters, :search_object_name => params[:search_object_name]}}
      format.json { 
        @cities.map!{|c|
          {
            :id => c.id,
            :name => c.name
          }
        }
        render :json => @cities
      }
    end
  end

  def cities
    @cities = City.find(:all,  :order => 'name') # , :conditions => ['name LIKE ?', "#{params[:term]}%"], :limit => 16
    #      format.json  { render :json => @cities.to_json(:only => [:id, :url])}

    respond_to do |format|
      format.html {render :inline => '<option></option><%= options_from_collection_for_select(@cities, "id", "name") %>'}
      format.json {
        @cities.map!{|c|
          {
            :id => c.id,
            :name => c.name
          }
        }
        @cities.unshift({:id => '', :name => ''})
        render :json => @cities
      }
    end
  end

  def update_address
    params[params[:input_id]] = params[:input_value]
    begin
      if params[:country_id]
        country = Country.find(params[:country_id])
        districts = District.find_all_by_country_id(country.id)
        municipalities = districts.empty? ? [] : Municipality.find_all_by_district_id(params[:district_id])
        cities = municipalities.empty? ? [] : City.find_all_by_municipality_id(municipalities.first.id)
        quarters = cities.empty? ? [] : Quarter.find_all_by_city_id(cities.first.id)

        @update_options = [[:district_id, districts, :name], [:municipality_id, municipalities, :name], [:city_id, cities, :name_with_type], [:quarter_id, quarters, :name]]
      elsif params[:district_id]
        municipalities = Municipality.find_all_by_district_id(params[:district_id])
        cities = municipalities.empty? ? [] : City.find_all_by_municipality_id(municipalities.first.id)
        quarters = cities.empty? ? [] : Quarter.find_all_by_city_id(cities.first.id)

        @update_options = [[:municipality_id, municipalities, :name], [:city_id, cities, :name_with_type], [:quarter_id, quarters, :name]]
      elsif params[:municipality_id]
        cities = City.find_all_by_municipality_id(params[:municipality_id])
        quarters = cities.empty? ? [] : Quarter.find_all_by_city_id(cities.first.id)

        @update_options = [[:city_id, cities, :name_with_type], [:quarter_id, quarters, :name]]
      elsif params[:city_id]
        quarters = Quarter.find_all_by_city_id(params[:city_id])
        @update_options = [[:quarter_id, quarters, :name]]
      else
        @update_options = [[:district_id, [], :name], [:municipality_id, [], :name], [:city_id, [], :name], [:quarter_id, [], :name]]
      end
    rescue ActiveRecord::RecordNotFound => e
      @update_options = [[:district_id, [], :name], [:municipality_id, [], :name], [:city_id, [], :name], [:quarter_id, [], :name]]
    end

    respond_to do |format|
      format.js { }
      format.html { }
    end
  end

end
