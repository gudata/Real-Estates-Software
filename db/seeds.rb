#
# data=parnter rake db:seed
# echo $data; RAILS_ENV=production rake db:migrate:reset; RAILS_ENV=production rake db:reset
#
# http://faker.rubyforge.org/rdoc/
require 'md5'

# когато е true зарежда всички области, общини и градове
# от cvs файловете в директория db, отнема много време

I18n.locale = :bg

def get_some_address
  Address.create({
      :country_id => Country.first.id, :district_id => Country.first.districts.first.id,
      :municipality_id => Country.first.districts.first.municipalities.first.id,
      :city_id => Country.first.districts.first.municipalities.first.cities.first.id,
      :quarter_id => Country.first.districts.first.municipalities.first.cities.first.quarters.first.id,
      :street => Faker::Address.street_name,
      :number => Faker::Address.zip_code,
      :entrance => %w( A B C D E F G).rand,
      :floor => rand(5),
      :apartment => %w( 1a 1B 1C 2D 2E 3F 1G).rand,
    }
  )
end

begin

  puts "Изтриваме mongo_to"
  Buy.delete_all
  SellDocument.delete_all
  BuyStatus.delete_all
  
  puts "Добаване на ролите"
  @manager = Role.create!(:name =>"Мениджър", :ident => 0, :parent_id => nil )
  @team_manager = Role.create!(:name =>"Мениджър екип", :ident => 1, :parent_id => @manager.id)
  @consultant = Role.create!(:name =>"Консултант", :ident => 2, :parent_id => @team_manager.id)
  @partner = Role.create!(:name =>"Партньор", :ident => 3, :parent_id => @manager)
  @guest = Role.create!(:name =>"Гост", :ident => 4, :parent_id => @manager)

  puts "Добавяне на държави"
  [
    "България",
    "Русия"
  ].each do |name|
    puts "+ #{name}"
    Country.create!(:name => name)
  end

  if true
    puts "Добавяне на градове"
    [
      "обл. София", "обл. Пловдив"
    ].each do |name|
      puts "+ #{name}"
      District.create(:name => name, :country_id => 1)
    end
  
    puts "Добавяне на общини"
    municiaplities = [
      [{:name => "общ. София", :district_id => 1}, {:name => "oбщ. Ботевград", :district_id => 1}],
      [{:name => "общ. Пловдив", :district_id => 2}, {:name => "oбщ. Асеновград", :district_id => 2}]
    ]
    Municipality.create!(municiaplities)
  
    puts "Добавяне на градове и села"
    cities = [
      [
        {:name => "София", :place_type => "гр.", :municipality_id => 1, :kind => 1},
        {:name => "Ботевград", :municipality_id => 2, :kind => 1, :place_type => "гр."}
      ],
      [
        {:name => "гр. Пловдив",  :municipality_id => 3, :kind => 1, :place_type => "гр."},
        {:name => "Асеновград",:place_type => "гр.", :municipality_id => 3, :kind => 1}],
      [
        {:name => "с. Село 1", :municipality_id => 1, :kind => 3, :place_type => "с."},
        {:name => "Село 2", :municipality_id => 2, :kind => 3, :place_type => "с."}
      ]
    ]
    City.create!(cities)
  
    puts "Добавяне на квартали"
    quarters = [
      [{:name => "кв. Овча купел", :city_id => 1}, {:name => "кв. Люлин", :city_id => 1}],
      [{:name => "кв. Квартал 1", :city_id => 2}, {:name => "кв. Квартал 2", :city_id => 2}],
      [{:name => "кв. Боженци", :city_id => 3}, {:name => "кв. Мичурни", :city_id => 3}],
      [{:name => "кв. Печенеги", :city_id => 4}, {:name => "кв. Ралковец", :city_id => 4}],
      [{:name => "кв. Ботев", :city_id => 5}, {:name => "кв. Бенковски", :city_id => 5}],
      [{:name => "кв. Дръндеровци", :city_id => 6}, {:name => "кв. Бачково", :city_id => 6}],
    ]
    Quarter.create!(quarters)
  
    #    else
    #      include Places
    #      Places.populate
  
  end

  puts "Добавяне на сфери на влияние"
  spheres = [
    {:name => "Строители", :active => true},
    {:name => "Инвеститори", :active => true},
    {:name => "Конкуренти", :active => true},
    {:name => "Частно лице", :active => true},
    {:name => "Фарминг", :active => true}
  ]
  Sphere.create(spheres)

  puts "Добавяне на категории на контакти"
  contact_categories = [
    {:name => "Лични", :active => true},
    {:name => "Служебни", :active => true},
    {:name => "Банки", :active => true}
  ]
  ContactCategory.create(contact_categories)

  puts "Добавяне на типове телефони"
  phone_types = [
    {:name => "Служебен", :active => true},
    {:name => "Личен", :active => true},
    {:name => "Факс", :active => true}
  ]
  PhoneType.create(phone_types)

  puts "Добавяне на типове интернет комуникатори"
  internet_comunicator_types = [
    {:name => "Email", :active => true, :is_email => true},
    {:name => "Skype", :active => true, :is_email => false},
    {:name => "ICQ", :active => true,   :is_email => false}
  ]
  InternetComunicatorType.create(internet_comunicator_types)

  puts "Добавяне на статуси към проекти/оферти"
  statuses = [
    {:name => "Регистрирана", :hide_on_this_status => false, :default => true},
    {:name => "Сделка", :hide_on_this_status => true, :default => false},
    {:name => "Отказана", :hide_on_this_status => true, :default => false},
    {:name => "Предварителен договор", :hide_on_this_status => false, :default => false},
    {:name => "Екслузивен договор", :hide_on_this_status => false, :default => false},
    {:name => "Kомисионнен договор", :hide_on_this_status => false, :default => false},
    {:name => "Огледана", :hide_on_this_status => false, :default => false},
  ]
  Status.create(statuses)

  puts "Добавяне на статуси към оферти предлага"
  [
    {:name => "Предложен", :hide_on_this_buy_status => false},
    {:name => "Огледан", :hide_on_this_buy_status => false},
    {:name => "Отказана", :hide_on_this_buy_status => false},
  ].each do |status|
    BuyStatus.create(status)
  end

  puts "Добавяне на номек. обзвавеждане "
  furnishes = [
    {:name => "Обзаведен",},
    {:name => "Необзаведен",},
    {:name => "Обзвавеждане за офис",},
  ]
  Furnish.create(furnishes)

  puts "Добавяне на статус на завършване на прокет "
  project_stages = [
    {:name => "Акт-14"},
    {:name => "Акт-15"},
    {:name => "Акт-16"},
    {:name => "Незапочнат"}
  ]
  ProjectStage.create(project_stages)

  puts "Добавяне на източник"
  sources = [
    {:name => "Печатно издание",},
    {:name => "Интернет",},
    {:name => "Реклама",},
    {:name => "Контакт",},
  ]
  Source.create(sources)


  puts "Добавяне на типове конструкции на имот"
  construction_types = [
    {:name => "Панел", :active => true},
    {:name => "ЕПК", :active => true},
    {:name => "Тухла", :active => true},
    {:name => "Дървена сглобяема", :active => true}
  ]
  ConstructionType.create(construction_types)

  puts "Добавяне на типове разположение на имот"
  exposure_types = [
    {:name => "Ю", :active => true},
    {:name => "С", :active => true},
    {:name => "З", :active => true},
    {:name => "И", :active => true},
    {:name => "С/Ю", :active => true},
    {:name => "Ю/С", :active => true},
    {:name => "И/З", :active => true},
    {:name => "З/И", :active => true}
  ]
  ExposureType.create(exposure_types)

  puts "Добавяне на предназначение на имота"
  property_functions = [
    {:name => "Жилище", :active => true},
    {:name => "Офис", :active => true},
    {:name => "Ателие", :active => true},
    {:name => "Магазин", :active => true},
    {:name => "Склад", :active => true},
    {:name => "Хотел", :active => true},
    {:name => "Заведение", :active => true},
  ]
  PropertyFunction.create(property_functions)
  
  puts "Добавяне на типове отопление на имот"
  heating_types = [
    {:name => "ТЕЦ", :active => true},
    {:name => "Локален ТЕЦ", :active => true},
    {:name => "Климатик", :active => true},
    {:name => "Електрически уреди", :active => true},
    {:name => "Дърва/въглища", :active => true},
    {:name => "Газифициран", :active => true}
  ]
  HeatingType.create(heating_types)

  puts "Добавяне на типове инфраструктура"
  infrastructure_types = [
    {:name => "училище", :active => true},
    {:name => "детска градина", :active => true},
    {:name => "спортен комплекс", :active => true},
    {:name => "метро", :active => true},
    {:name => "градски транспорт", :active => true},
    {:name => "парк", :active => true},
    {:name => "здравно заведени", :active => true},
    {:name => "супер маркет", :active => true}
  ]
  InfrastructureType.create(infrastructure_types)

  puts "Добавяне на типове пътища"
  road_types = [
    {:name => "черен път", :active => true},
    {:name => "асфалтов път", :active => true},
    {:name => "без път", :active => true},
    
  ]
  RoadType.create(road_types)

  puts "Добавяне на типове помещения"
  room_types = [
    {:name => "спалня", :active => true},
    {:name => "кухня", :active => true},
    {:name => "баня", :active => true},
    {:name => "стая", :active => true},
    {:name => "сухо помещение", :active => true},
    {:name => "WC", :active => true},
    {:name => "дневна", :active => true},
    {:name => "таван", :active => true},
    {:name => "мазе", :active => true},
    {:name => "гараж", :active => true},
    {:name => "паркоместа", :active => true},
  ]
  RoomType.create(room_types)

  puts "Добавяне на типове апартаменти"
  apartment_types = [
    {:name => "Гарсониера", :active => true},
    {:name => "Боксониера", :active => true},
    {:name => "Студио", :active => true},
    {:name => "Едностаен", :active => true},
    {:name => "Двустаен", :active => true},
    {:name => "Тристаен", :active => true},
    {:name => "Четиристаен", :active => true},
    {:name => "Многостаен", :active => true},
  ]
  ApartmentType.create(apartment_types)

  puts "Добавяне на типове постройки"
  building_types = [
    {:name => "барака", :active => true},
    {:name => "лятна кухня", :active => true},
    {:name => "склад", :active => true},
  ]
  BuildingType.create(building_types)

  puts "Добавяне на типове огради"
  fence_types = [
    {:name => "плет", :active => true},
    {:name => "мрежа", :active => true},
    {:name => "дървена", :active => true},
    {:name => "масивна", :active => true}
  ]
  FenceType.create(fence_types)

  puts "Добавяне на типове локации на имот"
  property_locations = [
    {:name => "В офис сграда", :active => true},
    {:name => "В търговск център", :active => true},
    {:name => "В жилищна сграда", :active => true},
    {:name => "В МОЛ", :active => true},
    {:name => "В хотелски комплекс", :active => true}
  ]
  PropertyLocation.create(property_locations)

  puts "Добавяне на категории местоположения на имот"
  property_category_locations = [
    {:name => "На море", :active => true},
    {:name => "На планина", :active => true},
    {:name => "На СПА курорт", :active => true},
    {:name => "В град", :active => true},
    {:name => "На село", :active => true}
  ]
  PropertyCategoryLocation.create(property_category_locations)

  puts "Добавяне на типове валидации за ключовите думи"
  validation_types = [
    {:name => "validates_presence_of", :active => true},
    {:name => "validate_numericality_of", :active => true},    
  ]
  ValidationType.create(validation_types)

  puts "Добавяне на стандартен избор"
  standart_choices = [
    {:name => "Да", :active => true, :position => 1},
    {:name => "Не", :active => true, :position => 2}
  ]
  StandartChoice.create(standart_choices)

  puts "Добавяне на типове оферти"

  offer_types = [
    {
      :name => "Купува",
      :category => OfferType::BUY_TYPE,
      :active => true,
      :tag => Contact::TAG_BUYERS,
      :oposite_offer_type_id => 3,
    },
    {
      :name => "Наема",
      :category => OfferType::BUY_TYPE,
      :active => true,
      :tag => Contact::TAG_RENTERS,
      :oposite_offer_type_id => 4,
    },
    {:name => "Продава",
      :category => OfferType::SELL_TYPE,
      :active => true,
      :tag => Contact::TAG_SELLERS,
      :oposite_offer_type_id => 1,
    },
    {:name => "Отдава",
      :category => OfferType::SELL_TYPE,
      :active => true,
      :tag => Contact::TAG_LETTERS,
      :oposite_offer_type_id => 2,
    },
  ]
  OfferType.create(offer_types)

  
  puts "Добавяне на атрибути за шаблоните на имоти"
  keywords = [
    {:name => 'Цена', :tag => 'price', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Цена на клиента', :tag => 'price_client', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Цена валута', :tag => 'price_metric', :patern => 'String', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Площ', :tag => 'area', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Мярка за площ', :tag => 'area_metric', :patern => 'String', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Застроена площ', :tag => 'build_up_area', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Обща площ', :tag => 'totla_area', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Стаи', :tag => 'rooms', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Дата на строеж', :tag => 'building_date', :patern => 'Date', :as => 'calendar', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Предназначение', :tag => 'used_for', :patern => 'PropertyFunction', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => "Категория", :tag => 'category', :patern => 'PropertyCategoryLocation', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => 'Конструкция', :tag => 'construction', :patern => 'ConstructionType', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => 'Ново строителство', :tag => 'new_development',:patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Етаж', :tag => 'floor', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Етажи', :tag => 'floors', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Тераси', :tag => 'balconies', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Разположение', :tag => 'exposure', :patern => 'ExposureType', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => 'Преходен', :tag => 'transitional', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Обзавеждане', :tag => 'furniture', :patern => 'Furnish', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => 'Отопление', :tag => 'heating', :patern => 'HeatingType', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => 'Асансьор', :tag => 'elevator', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Телефон', :tag => 'phone', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Кабелна', :tag => 'cable_tv', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Интернет', :tag => 'internet', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Обезопасен', :tag => 'secured', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'СОТ', :tag => 'sot', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Гараж', :tag => 'garage', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Площ на гаража', :tag => 'garage_area', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Парко место', :tag => 'parking_seat', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Добра локация', :tag => 'good_location', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Инфраструктура', :tag => 'infrastructure', :patern => 'InfrastructureType', :as => 'check_boxes', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => 'Вид апартамент', :tag => 'apartment_type', :patern => 'ApartmentType', :as => 'check_boxes', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => 'Намира се в', :tag => 'located_in', :patern => 'PropertyLocation', :as => 'multiple_select', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => 'Open space', :tag => 'open_space', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Височина на витрината', :tag => 'shop_window_height', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Склад', :tag => 'storage', :patern => 'Integer', :as => 'Integer', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Площ на склада', :tag => 'storage_area', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Двор', :tag => 'yard', :patern => 'Integer', :as => 'Integer', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Площ на двора', :tag => 'yard_area', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Електричество', :tag => 'electricity', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Вода', :tag => 'water', :patern => 'Integer', :as => 'boolean', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Канализация', :tag => 'sewerage', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Път', :tag => 'road', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Тип на пътя', :tag => 'road_type', :patern => 'RoadType', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => 'Лице към пътя', :tag => 'face_ towards_road', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Виза за строеж', :tag => 'visa', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Ограда', :tag => 'fence', :patern => 'FenceType', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:multiple]},
    {:name => 'Брой места', :tag => 'seets', :patern => 'Integer', :as => 'string', :kind_of_search => Keyword::KIND_OF_SEARCH[:range]},
    {:name => 'Обурудване', :tag => 'equipment', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
    {:name => 'Лиценз', :tag => 'licens', :patern => 'StandartChoice', :as => 'select', :kind_of_search => Keyword::KIND_OF_SEARCH[:exact]},
  ]
  keywords.map{|hash| hash[:active] = true}
  
  Keyword.create(keywords)
  
  # Шаблони
  template_keywords =
    {
    "Апартамент" => ["Цена", 'Цена на клиента', 'Цена валута', "Площ", "Стаи", "Етаж", "Тераси", "Площ на гаража",
      "Дата на строеж", "Предназначение", "Категория", "Конструкция", "Разположение",
      "Обзавеждане", "Отопление", "Ново строителство", "Преходен", "Асансьор",
      "Телефон", "Кабелна", "Гараж", "Интернет", "Обезопасен", "Парко место", "Инфраструктура", "Вид апартамент"
    ],
    
    "Къща" => ["Цена", 'Цена на клиента', 'Цена валута', "Площ", "Стаи", "Етаж", "Дата на строеж", "Предназначение", "Категория", "Конструкция",
      "Ново строителство", "Тераси", "Разположение", "Преходен", "Обзавеждане", "Отопление", "Асансьор",
      "Телефон", "Кабелна", "Интернет", "Обезопасен", "Гараж", "Площ на гаража", "Парко место", "Инфраструктура",
      "Застроена площ", "Обща площ", "Добра локация", "Площ на двора", ],
    "Заведение" => ["Цена", 'Цена на клиента', 'Цена валута', "Площ", "Стаи", "Етаж", "Дата на строеж", "Предназначение", "Категория", "Конструкция",
      "Ново строителство", "Тераси", "Разположение", "Преходен", "Обзавеждане", "Отопление", "Асансьор",
      "Телефон", "Кабелна", "Интернет", "Обезопасен", "Гараж", "Площ на гаража", "Парко место", "Инфраструктура",
      "Застроена площ", "Обща площ", "Добра локация", "Площ на двора", ],
    "Хотел" => ["Цена", 'Цена на клиента', 'Цена валута', "Площ", "Стаи", "Етаж", "Дата на строеж", "Предназначение", "Категория", "Конструкция",
      "Ново строителство", "Тераси", "Разположение", "Преходен", "Обзавеждане", "Отопление", "Асансьор",
      "Телефон", "Кабелна", "Интернет", "Обезопасен", "Гараж", "Площ на гаража", "Парко место", "Инфраструктура",
      "Застроена площ", "Обща площ", "Добра локация", "Площ на двора", ],
    "Етаж от къща" => ["Цена", 'Цена на клиента', 'Цена валута', "Площ", "Стаи", "Етаж", "Дата на строеж", "Предназначение", "Категория", "Конструкция",
      "Ново строителство", "Тераси", "Разположение", "Преходен", "Обзавеждане", "Отопление", "Асансьор",
      "Телефон", "Кабелна", "Интернет", "Обезопасен", "Гараж", "Площ на гаража", "Парко место", "Инфраструктура",
      "Застроена площ", "Обща площ", "Добра локация", "Площ на двора", ],
    "Парцел" => ["Цена", 'Цена на клиента', 'Цена валута', "Площ", 'Мярка за площ', "Предназначение", "Категория",
      "Разположение",  "Отопление", 
      "Телефон", "Кабелна", "Интернет", "Обезопасен","Парко место", 
      "Добра локация", ],
    "Земеделска земя" => ["Цена", 'Цена на клиента', 'Цена валута', "Площ", 'Мярка за площ', "Предназначение", "Категория",
      "Разположение",  "Отопление",
      "Телефон", "Кабелна", "Интернет", "Обезопасен","Парко место",
      "Добра локация", ],
    "Офис" => ["Цена", 'Цена на клиента', 'Цена валута', "Площ", "Стаи", "Етаж", "Дата на строеж", "Предназначение", "Категория", "Конструкция",
      "Ново строителство", "Тераси", "Разположение", "Преходен", "Обзавеждане", "Отопление", "Асансьор",
      "Телефон", "Кабелна", "Интернет", "Обезопасен", "Гараж", "Площ на гаража", "Парко место", "Инфраструктура",
      "Добра локация", "Намира се в", "Open space"],
    "Магазин" => ["Цена", 'Цена на клиента', 'Цена валута', "Площ", "Стаи", "Етаж", "Дата на строеж", "Предназначение", "Категория", "Конструкция",
      "Ново строителство",  "Разположение", "Отопление", "Асансьор",
      "Телефон", "Кабелна", "Интернет", "Обезопасен", "Гараж", "Площ на гаража", "Парко место", "Инфраструктура",
      "Добра локация", "Намира се в", ],
    "Склад" => ["Цена", 'Цена на клиента', 'Цена валута', "Площ", 'Мярка за площ', "Дата на строеж", "Предназначение", "Категория", "Конструкция",
      "Ново строителство",  "Разположение", "Преходен", "Обзавеждане", "Отопление", "Асансьор",
      "Телефон", "Кабелна", "Интернет", "Обезопасен", "Инфраструктура",
      "Добра локация", "Намира се в", ],
  }

  puts "Добавяне на шаблони за типовете имоти"
  property_types = [
    {:name => "Апартамент", :active => true},
    {:name => "Офис", :active => true},
    {:name => "Къща", :active => true},
    {:name => "Парцел", :active => true},
    {:name => "Магазин", :active => true},
    {:name => "Склад", :active => true},
  ]
  property_types.each do |property_type_template|
    property_type = PropertyType.create(property_type_template)
    puts "Добавяне на шаблон за #{property_type_template[:name]}"
    template_keywords[property_type_template[:name]].each do |keyword_name|

      founded_keyword = Keyword.find_by_name(keyword_name).first
      raise "keyword #{keyword_name} not found. Has been created infront?" unless founded_keyword

      KeywordsPropertyType.new(
        :end_of_line => false,
        :style => '',
        :property_type_id => property_type.id,
        :keyword_id => founded_keyword.id
      )
    end
  end

  [
    {:position => 0, :active => true, :name => "Изтекла"},
    {:position => 1, :active => true, :name => "Спряна"},
    {:position => 2, :active => true, :name => "Продадена"},
  ].each {|canceled_type| CanceledType.create(canceled_type)}



  [
    {:position => 0, :active => true, :value => 0, :name => "Улица"},
    {:position => 1, :active => true, :value => 1, :name => "Булевард"},
    {:position => 2, :active => true, :value => 2, :name => "Алея"},
  ].each { |street| StreetType.create(street) }

  [
    {:position => 0, :active => true, :value => -2, :name => "Ниво 2"},
    {:position => 1, :active => true, :value => -1, :name => "Ниво 1"},
    {:position => 2, :active => true, :value => 0, :name => "Приземен"},
    {:position => 3, :active => true, :value => 0, :name => "Партер"},
    {:position => 4, :active => true, :value => 1, :name => "Първи"},
    {:position => 5, :active => true, :value => 2, :name => "Втори"},
    {:position => 6, :active => true, :value => 3, :name => "Трети"},
    {:position => 7, :active => true, :value => 4, :name => "Червърти"},
    {:position => 8, :active => true, :value => 5, :name => "Пети"},
    {:position => 9, :active => true, :value => 6, :name => "Шести"},
    {:position => 10, :active => true, :value => 7, :name => "Седми"},
    {:position => 11, :active => true, :value => 8, :name => "Осми"},
    {:position => 12, :active => true, :value => 9, :name => "Девети"},
    {:position => 13, :active => true, :value => 10, :name => "Десети"},
    {:position => 14, :active => true, :value => 11, :name => "Единадесети"},
    {:position => 15, :active => true, :value => 12, :name => "Дванадасети"},
    {:position => 16, :active => true, :value => 13, :name => "Тринадесети"},
    {:position => 17, :active => true, :value => 14, :name => "Четиринадесети"},
  ].each {|floor| FloorType.create(floor)}

  
  if ENV["data"].blank?
    puts "Импорт настройките за режим разработка - параметър data в environment-а показва друг файл с данни."
    import_file = "development"
  else
    puts "Импорт на настройките за #{import_file}"
    import_file = ENV["data"] #@partner
  end
  
  require File.join(::Rails.root, "db", "custom_seed", "#{import_file}.rb")

rescue ActiveRecord::RecordInvalid => invalid
  puts invalid.record.errors.full_messages
end
