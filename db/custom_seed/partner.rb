puts "******* добавяне на данните за partner-bulgaria ********"
puts "Импорт на смелените населени места"
config   = Rails::Configuration.new
host     = config.database_configuration[RAILS_ENV]["host"]
database = config.database_configuration[RAILS_ENV]["database"]
username = config.database_configuration[RAILS_ENV]["username"]
password = config.database_configuration[RAILS_ENV]["password"]

# mysqldump -u root re_production district district_translations Municipalities municipality_translations Cities city_translations > 24h-cities.sql
puts "mysql -h #{host} -u#{username} -p#{password}  #{ActiveRecord::Base.connection.current_database} < #{RAILS_ROOT}/db/24h-cities.sql"
`mysql -h #{host} -u#{username} -p#{password}  #{ActiveRecord::Base.connection.current_database} < #{RAILS_ROOT}/db/24h-cities.sql`

puts "Добавяне на офиси"
office_varna = Office.create({:name => "Варна", :address_id => get_some_address.id,
    :phone => "02 444 555", :mobile_phone => "0888 888 999",
    :fax => "02 345 678"})
office_burgas = Office.create({:name => "Бургас", :address_id => get_some_address.id,
    :phone => "02 555 666", :mobile_phone => "0777 222 333",
    :fax => "02 123 456"})
office_bansko = Office.create({:name => "Банско", :address_id => get_some_address.id,
    :phone => "02 555 666", :mobile_phone => "0777 222 333",
    :fax => "02 123 456"})
office_sofia = Office.create({:name => "София", :address_id => get_some_address.id,
    :phone => "02 555 666", :mobile_phone => "0777 222 333",
    :fax => "02 123 456"})

HUMAN_ROLE = {
  "Мениджър на екип" => [@team_manager, false], # false/true - assistant
  "Асистент на мениджър на екип" => [@team_manager, true],
  "Консултант" => [@consultant, false],
}

puts "Добавяме потребителите"
the_boss = User.create!(:login => "the boss", :email => "boss@boss.com", :role => @manager,
  :first_name => "Петър", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222', :password => '1122', :password_confirmation => '1122', :parent_id => nil,  :office_id => 1, :team_id => 1, :assistant => false)

boss_secretary = User.create!(:login => "boss secretary", :email => "secretary@boss.com", :role => @manager, :assistant => true,
  :first_name => "Мария", :second_name => "Петров", :last_name => "Петров", :mobile => '11', :phone => '222', :password => '1122', :password_confirmation => '1122', :parent_id => the_boss.id,  :team_id => 1, :office_id => 1)


company_users = {
  office_burgas => {
    "Екип 1 - Бургас" => [
      "Мениджър на екип, Анелия Савова, asavova@partnerbulgaria.eu, 0886922833",
      "Асистент на мениджър на екип, Катина Чернова, kchernova@partnerbulgaria.eu, 0886700142",
      "Консултант, Вячеслав Фурника, vfurnika@partnerbulgaria.eu, 0886700184",
    ]
  },
  office_bansko => {
    "Екип 1 - Банско" => [
    ],
  },
  office_varna => {
    "Екип 1 - Варна" => [
      "Мениджър на екип, Здравко Ценов, ztsenov@partnerbulgaria.eu, 0884495057",
      "Асистент на мениджър на екип, Виктория Добрева, vdobreva@partnerbulgaria.eu, 0887780499",
      "Консултант, Донко Колев, dkolev@partnerbulgaria.eu, 0889998916",
      "Консултант, Мариаяна Донева, mdoneva@partnerbulgaria.eu, 0885470570",
      "Консултант, Радина Атанасова, ratanasova@partnerbulgaria.eu, 0884343758",
      "Консултант, Радостина Кръстева, rkrusteva@partnerbulgaria.eu, 0886700276",
    ],
  },
  office_sofia => {
    "Екип 1 - София" => [
      "Мениджър на екип, Вероника Петкова, vpetkova@partnerbulgaria.eu, 0888550913",
      "Асистент на мениджър на екип, Петя Христова, phristova@partnerbulgaria.eu, 0885881244",
      "Консултант, Антон Панкев, apankev@partnerbulgaria.eu, 0884750612",
      "Консултант, Даниела Тодорова, dtodorova@partnerbulgaria.eu, 0884207930",
      "Консултант, Елена Миланова, eradilova@partnerbulgaria.eu, 0885922634",
      "Консултант, Марина Стоянова, mstoyanova@partnerbulgaria.eu, 0882477690",
      "Консултант, Михаил Киселев, mkisselev@partnerbulgaria.eu, 0882477890",
      "Консултант, Радослав Тамбуков, rtambukov@partnerbulgaria.eu, 0885838349",
      "Консултант, Ралица Петкова, rpetkova@partnerbulgaria.eu, 0887598922",
    ],
  },
}.each do |office, teams|
  teams.each do |team_name, members|
    team = Team.create({:name => team_name, :active => true})
    the_team_manager = nil
    members.each do |string|
      (role_human, name, email, gsm) = string.split(",")
      login, fake = email.split("@")
      role, assistant = HUMAN_ROLE[role_human]

      first_name, second_name, last_name = name.split(" ")
      if last_name.blank?
        last_name = second_name
        second_name = ""
      end

      parent = nil
      case role.to_sym
      when :team_manager
        if assistant
          parent = the_team_manager
        else
          parent = the_boss
        end
      when :consultant
        raise "шефа трябва да е известен преди да правим членовете на екипа" if the_team_manager.blank?
        parent = the_team_manager
      end
      
      user_data = {
        :login => login.strip,
        :email => email.strip,
        :role => role,
        :first_name => first_name.strip,
        :second_name => second_name.strip,
        :last_name => last_name.strip,
        :mobile => gsm.strip,
        :phone => '',
        :password => '1122',
        :password_confirmation => '1122',
        :parent_id => parent.id,
        :office_id => office.id,
        :team_id => team.id,
        :assistant => assistant,
      }
      user = User.create!(user_data)

      the_team_manager = user if role.to_sym == :team_manager and !assistant
    end
  end
end

##  puts "Добавяне на контакти"
##  contacts = {:is_company => false, :person_first_name => {Faker::Name.first_name => "Christophe"} , :person_last_name => {Faker::Name.first_name => "Пешев"}, :added_by => 1, :nationality_id => 1, :address_id => 1}
#User.all.each do |user|
#  if user.role?(:manager) or user.role?(:team_manager) or user.role?(:consultant)
#    puts "Добавяне на контакти за потребител #{user.email}"
#    4.times do
#      contacts = {
#        :added_by => 1,
#        :address_id => get_some_address.id,
#        :is_company => false,
#        :person_first_name => Faker::Name.first_name,
#        :person_last_name => Faker::Name.last_name,
#        :nationality_id => 1,
#        :key => MD5.md5(rand(123123123).to_s).to_s
#      }
#
#      contact = Contact.new(contacts)
#
#      contact.phones.build(:number => Faker::PhoneNumber.phone_number, :phone_type_id => 1)
#      contact.internet_comunicators.build(:value => Faker::Internet.free_email, :internet_comunicator_type_id => 1)
#      contact.users << user
#      unless contact.valid?
#        puts contact.errors.full_messages
#      end
#      contact.save
#
#    end
#  end
#end
#ContactsUser.update_all('is_client = 1')
#
#
#puts "Добавяне на оферти към контакти"
#User.all.each do |user|
#  user.contacts.all.each do |contact|
#    if user.role?(:manager) or user.role?(:team_manager) or user.role?(:consultant)
#      2.times do
#        PropertyType.all(:include => {:keywords_property_types => []}).each do |property_type|
#          offer = Sell.new(
#            :address_id => get_some_address.id,
#            :property_type => property_type,
#            :status => Status.all.rand,
#            :user => user,
#            :contact => contact,
#            :source => Source.all.rand,
#            :source_value => Faker::Name.first_name,
#            :offer_type => OfferType.all(:conditions => {:category => OfferType::SELL_TYPE}).rand,
#            :keywords_sells =>
#              [
#              KeywordsSell.new(:keyword_id => Keyword.find_by_tag("price").id, :value => 50000),
#              KeywordsSell.new(:keyword_id => Keyword.find_by_tag("area").id, :value => 50),
#              KeywordsSell.new(:keyword_id => Keyword.find_by_tag("category").id, :value => PropertyCategoryLocation.all.rand.id.to_s),
#              KeywordsSell.new(:keyword_id => Keyword.find_by_tag("used_for").id, :value => PropertyFunction.all.rand.id.to_s),
#              KeywordsSell.new(:keyword_id => Keyword.find_by_tag("infrastructure").id, :value => InfrastructureType.all.collect{|e|e.id}.join(","))
#            ]
#          )
#          #            puts offer.errors.full_messages
#          offer.save
#        end
#      end
#    end
#  end
#end
#
#puts "Добавяне на примерен проект"
#Contact.all.each do |contact|
#  User.all.each do |user|
#    2.times do
#      if user.role?(:mnager) or user.role?(:@team_manager) or user.role?(:@consultant)
#        Project.create(
#          :name => "Резиденция #{user.login.capitalize}",
#          :status_id => Status.all.rand.id,
#          :source_id => Source.all.rand.id,
#          :furnish_id => Furnish.all.rand.id,
#          :team_id => Team.first,
#          :user_id => user.id,
#          :contact_id => contact.id,
#          :address_id => addresses.rand.id,
#          :source_value => 10,
#          :contact_person => "Мариела",
#          :contact_person_phone => "123123123",
#          :website => "http://www.cenite.com",
#          :start_date => "",
#          :finish_date => "2010-02-10",
#          :reference_point => "",
#          :property_category_location_id => [1,2,3].rand,
#          :managment_fee => 123.3,
#          :discount => 3.3,
#          :brokerage => 4.4,
#          :description => "Със златни дръжки по прозорците",
#          :additional_description => "Отиди и виж сам.",
#          :active => true,
#          :project_stage_id => [1,2,3].rand
#        )
#      end
#    end
#  end
#end


___END___









Автогора
Аспарухово
Бриз
Виница
ВИНС
Владиславово
Военна болница
Възраждане
Галата
Гръцка махала
Дружба
Електрон
ЖП Гара
Завод Дружба
Западна пром.зона
ЗК Тракия
Идеален център
Изгрев
Кайсиева градина
Колхозен пазар
Левски
ЛК Тракия
Младост
Морска градина
Нептун
Нов хлебозавод
Общината
Окръжна болница
Победа
Погребите
Спортна зала
Техникумите
Трошево
ХЕИ
Христо Ботев
Цветен
Централен
Почивка - вилна зона
Златни пясъци - курортен комплекс
Камчия - курортен комплекс
Св.Константин - курортен комплекс
Слънчев ден - курортен комплекс
Акчелар - местност
Ален Мак - местност
АОНСУ - местност
Арабско селище - местност
Аязмото - местност
Боровец - местност
Ваялар - местност
Геолога - местност
Горна Трака - местност
Дилбер Чешма - местност
Добрева Чешма - местност
Долна Трака - местност
Дървен мост - местност
Евксиноград - местност
Журналист - местност
Зеленика - местност
Кабакум - местност
Манастирски рид - местност
Марек - местност
Перчемлията - местност
Прибой - местност
Ракитника - местност
Св. Никола - местност
Сотира - местност
Спорт Палас - местност
Средна Трака - местност
Топра Хисар - местност
Траката - местност




Бургас

Братя Миладинови
Банево
Ветрен
Възраждане
Горно Езерово
Долно Езерово
Зорница
Изгрев
Индустриална зона
Крайморие
Лазур
Лозово
Меден рудник
Метро
Победа
Сарафово
Северна промишлена зона
Славейков
Център
Широк център
5-ти километър


София

Аерогарата
Бакърена фабрика
Банишора
Банкя
Белите брези
Беловодски път
Бенковски
Бистрица
Борово
Бояна
Бункера
Бъкстон
Витоша
Владая
Враждебна
Гара Искър
Гевгелийски
Гео Милев
Герман
Горна Баня
Горубляне
Гоце Делчев
Дианабад
Драгалевци
Дружба 1
Дружба 2
Дървеница
Западен парк
Захарна фабрика
Зона Б-18
Зона Б-19
Зона Б-5
Иван Вазов
Изгрев
Изток
Илинден
Илиянци
Килиите
Киноцентъра
Княжево
Красна поляна
Красно село
Кремиковци
Крива река
Кръстова вада
Лагера
Лев Толстой
Левски
Левски - В
Левски - Г
Лозенец
Люлин 1
Люлин 10
Люлин 2
Люлин 3
Люлин 4
Люлин 5
Люлин 6
Люлин 7
Люлин 8
Люлин 9
Люлин център
Малашевци
Малинова долина
Манастирски ливади
Медицинска академия
Младост 1
Младост 1 А
Младост 2
Младост 3
Младост 4
Модерно предградие
Мотописта
Мусагеница
Надежда 1
Надежда 2
Надежда 3
Надежда 4
Надежда 5
Надежда 6
Обеля
Обеля 1
Обеля 2
Оборище
Овча Купел
Овча купел 1
Овча купел 2
Орландовци
Павлово
Панчарево
Подуене
Полигона
Разсадника
Редута
Република
Света Троица
Свобода
Сердика
Симеоново
Славия
Слатина
Стефан Караджа
Стрелбище
Студентски град
Сухата река
Суходол
Толстой
Триъгълника
Хаджи Димитър
Хиподрума
Хладилника
Централна гара
Център
Яворов

