class Admin::AddressesController < Admin::BaseController

  def index
    @address = Address.first
  end
  
  def show
    @address = Address.find(params[:id])
  end

  def render_map
    respond_to do |format|
      format.js {
        address = Geokit::Geocoders::GoogleGeocoder.geocode(params[:address])
        @map = GoogleMap::Map.new
        @map.markers << GoogleMap::Marker.new(:map => @map,
          :icon => GoogleMap::SmallIcon.new(@map, 'blue'),
          :lat => address.lat,
          :lng => address.lng,
          :open_infoWindow => true,
          :html => address.to_geocodeable_s)
        @map.zoom = 16
        @map1 = @map.to_html
      }
    end
  end

  def new
    @address = User.first.office.address
  end
  
  def create
    @address = Address.new(params[:address])
    if @address.save
      flash[:notice] = "Successfully created address."
      redirect_to @address
    else
      render :action => 'new'
    end
  end
  
  def edit
    @address = Address.find(params[:id])
  end
  
  def update
    @address = Address.find(params[:id])
    @address.reload
    if @address.update_attributes(params[:address])
      render :partial => "show_address", :layout => nil
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    flash[:notice] = "Successfully destroyed address."
    redirect_to addresses_url
  end

  def get_districts
    respond_to do |format|
      format.js {
        @quarters = Quarter.all(:include => :translations,
          :conditions => ["quarter_translations.name LIKE ?", "%#{params[:q]}%"],
          :limit => params[:limit]
        )
        @quarters.map!{|quarter|
          "#{quarter.city.municipality.district.country.name} -> #{quarter.city.municipality.district.name} -> #{quarter.city.municipality.name} -> #{quarter.city.name} -> #{quarter.name}\n"
        }

        @cities = City.all(:include => :translations,
          :conditions => ["city_translations.name LIKE ?", "%#{params[:q]}%"],
          :limit => params[:limit]
        )
        @cities.map!{|city|
          "#{city.municipality.district.country.name} -> #{city.municipality.district.name} -> #{city.municipality.name} -> #{city.municipality.name}\n"
        }

        @municipalities = Municipality.all(:include => :translations,
          :conditions => ["municipality_translations.name LIKE ?", "%#{params[:q]}%"],
          :limit => params[:limit]
        )
        @municipalities.map!{|municipality|
          "#{municipality.district.country.name} -> #{municipality.district.name} -> #{municipality.name}\n"
        }


        @districts = District.all(:include => :translations,
          :conditions => ["district_translations.name LIKE ?", "%#{params[:q]}%"],
          :limit => params[:limit]
        )
        @districts.map!{|district| "#{district.country.name} -> #{district.name}\n"}

        @places =  @quarters + @cities + @municipalities + @districts

      }
    end

  end

end
