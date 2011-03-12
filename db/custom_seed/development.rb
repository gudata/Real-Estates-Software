puts "Добавяне на екипи"
team = [
  {:name => "Бургас", :active => true},
  {:name => "Банско", :active => true},
  {:name => "Варна", :active => true},
  {:name => "София", :active => true},
]
Team.create(team)

puts "Добавяме потребителите"
the_boss = User.create!(:login => "the boss", :email => "boss@boss.com", :role => @manager,
  :first_name => "Петър", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222', :password => '1122', :password_confirmation => '1122', :parent_id => nil,  :office_id => 1, :team_id => 1, :assistant => false)

boss_secretary = User.create!(:login => "boss secretary", :email => "secretary@boss.com", :role => @manager, :assistant => true,
  :first_name => "Мария", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222', :password => '1122', :password_confirmation => '1122', :parent_id => the_boss.id,  :team_id => 1, :office_id => 1)

lider = User.create!(:login => "lider", :email => "lider@lider.com", :role => @team_manager, :assistant => false,
  :first_name => "Вожда", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222', :password => '1122', :password_confirmation => '1122', :parent_id => the_boss.id, :team_id => 2, :office_id => 2)

lidercho = User.create!(:login => "lidercho", :email => "lidecrcho@lider.com", :role => @team_manager, :assistant => true,
  :first_name => "Чапай", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222',  :password => '1122', :password_confirmation => '1122', :parent_id => lider.id, :team_id => 3, :office_id => 2)

dosadnik = User.create!(:login => "dosadnik", :email => "dasadnik@dosada.com", :role => @consultant,
  :first_name => "Петка", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222', :password => '1122', :password_confirmation => '1122', :parent_id => lider.id,  :team_id => 2, :office_id => 2)

dosadnik3 = User.create!(:login => "dosadnik3", :email => "dasadnik3@dosada.com", :role => @consultant,
  :first_name => "Марийка", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222',  :password => '1122', :password_confirmation => '1122', :parent_id => lider.id,  :team_id => 2, :office_id => 2)

lider2 = User.create!(:login => "lider2", :email => "lider2@lider.com", :role => @team_manager, :assistant => false,
  :first_name => "Бойко", :second_name => "Борисов", :last_name => "Петров", :mobile => '11', :phone => '222', :password => '1122', :password_confirmation => '1122', :parent_id => the_boss.id, :team_id => 2, :office_id => 2)

lidercho2 = User.create!(:login => "lidercho2", :email => "lidecrcho2@lider.com", :role => @team_manager, :assistant => true,
  :first_name => "Драган", :second_name => "Петров", :last_name => "Петров",  :mobile => '11', :phone => '222', :password => '1122', :password_confirmation => '1122', :parent_id => lider2.id,  :team_id => 4, :office_id => 3)

dosadnik2 = User.create!(:login => "dosadnik2", :email => "dasadnik2@dosada.com", :role => @consultant,
  :first_name => "Цанко", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222',  :password => '1122', :password_confirmation => '1122', :parent_id => lider2.id,  :team_id => 3, :office_id => 3)

rekmalcho = User.create!(:login => "reklamcho", :email => "company@frie.com", :role => @partner,
  :first_name => "Ралица", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222', :password => '1122', :password_confirmation => '1122', :parent_id => the_boss.id)

guest_user = User.create!(:login => "gost", :email => "gost@home.com", :role => @guest,
  :first_name => "Иван", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222',  :password => '1122', :password_confirmation => '1122', :parent_id => the_boss.id)


puts "Добавяне на адрес"
addresses = []
Country.all.each do |country|
  country.districts.each do |district|
    district.municipalities.each do |municipality|
      municipality.cities.each do |city|
        city.quarters.each do |quarter|
          addresses << Address.create({
              :country_id => country.id, :district_id => district.id,
              :municipality_id => municipality.id, :city_id => city.id,
              :quarter_id => quarter.id, :street => Faker::Address.street_name,
              :number => Faker::Address.zip_code, :entrance => %w( A B C D E F G).rand,
              :floor => rand(5), :apartment => %w( 1a 1B 1C 2D 2E 3F 1G).rand}
          )
        end
      end
    end
  end
end

#  puts "Добавяне на контакти"
#  contacts = {:is_company => false, :person_first_name => {Faker::Name.first_name => "Christophe"} , :person_last_name => {Faker::Name.first_name => "Пешев"}, :added_by => 1, :nationality_id => 1, :address_id => 1}
User.all.each do |user|
  if user.role?(:manager) or user.role?(:team_manager) or user.role?(:consultant)
    puts "Добавяне на контакти за потребител #{user.email}"
    4.times do
      contacts = {
        :added_by => 1,
        :address_id => 1,
        :is_company => false,
        :person_first_name => Faker::Name.first_name,
        :person_last_name => Faker::Name.last_name,
        :nationality_id => 1,
        :key => MD5.md5(rand(123123123).to_s).to_s
      }

      contact = Contact.new(contacts)

      contact.phones.build(:number => Faker::PhoneNumber.phone_number, :phone_type_id => 1)
      contact.internet_comunicators.build(:value => Faker::Internet.free_email, :internet_comunicator_type_id => 1)
      contact.users << user
      contact.save
    end
  end
end
ContactsUser.update_all('is_client = 1')


puts "Добавяне на оферти към контакти"
User.all.each do |user|
  user.contacts.all.each do |contact|
    if user.role?(:manager) or user.role?(:team_manager) or user.role?(:consultant)
      2.times do
        PropertyType.all(:include => {:keywords_property_types => []}).each do |property_type|
          offer = Sell.new(
            :address_id => Address.all.rand.id,
            :property_type => property_type,
            :status => Status.all.rand,
            :user => user,
            :contact => contact,
            :source => Source.all.rand,
            :source_value => Faker::Name.first_name,
            :offer_type => OfferType.all(:conditions => {:category => OfferType::SELL_TYPE}).rand,
            :keywords_sells =>
              [
              KeywordsSell.new(:keyword_id => Keyword.find_by_tag("price").id, :value => 50000),
              KeywordsSell.new(:keyword_id => Keyword.find_by_tag("area").id, :value => 50),
              KeywordsSell.new(:keyword_id => Keyword.find_by_tag("category").id, :value => PropertyCategoryLocation.all.rand.id.to_s),
              KeywordsSell.new(:keyword_id => Keyword.find_by_tag("used_for").id, :value => PropertyFunction.all.rand.id.to_s),
              KeywordsSell.new(:keyword_id => Keyword.find_by_tag("infrastructure").id, :value => InfrastructureType.all.collect{|e|e.id}.join(","))
            ]
          )
          #            puts offer.errors.full_messages
          offer.save
        end
      end
    end
  end
end

puts "Добавяне на примерен проект"
Contact.all.each do |contact|
  User.all.each do |user|
    2.times do
      if user.role?(:manager) or user.role?(:team_manager) or user.role?(:consultant)
        Project.create(
          :name => "Резиденция #{user.login.capitalize}",
          :status_id => Status.all.rand.id,
          :source_id => Source.all.rand.id,
          :furnish_id => Furnish.all.rand.id,
          :team_id => Team.first,
          :user_id => user.id,
          :contact_id => contact.id,
          :address_id => addresses.rand.id,
          :source_value => 10,
          :contact_person => "Мариела",
          :contact_person_phone => "123123123",
          :website => "http://www.cenite.com",
          :start_date => "",
          :finish_date => "2010-02-10",
          :reference_point => "",
          :property_category_location_id => [1,2,3].rand,
          :managment_fee => 123.3,
          :discount => 3.3,
          :brokerage => 4.4,
          :description => "Със златни дръжки по прозорците",
          :additional_description => "Отиди и виж сам.",
          :active => true,
          :project_stage_id => [1,2,3].rand
        )
      end
    end
  end
end 
