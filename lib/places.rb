# Зарежда всички, области, общини и градове
# Внимание, отнема много време


module Places

  require 'csv'

  def self.populate
    #създава временните таблици
    puts "Създаване на времените таблици"
    CreateOblasti.create
    CreateObshtini.create
    CreateEkatte.create


    oblasti = Oblast.all
    oblasti.each do |oblast| #цикли областите от времената таблица
      #създава област в постоянната таблица
      district = District.create(:name => oblast.name, :country_id => 1) 
      puts "Записана област : #{district.name}"
      obshtini = Obshtina.find_by_sql "SELECT * FROM obshtini WHERE SUBSTRING(obshtina, 1, 3) =  '#{oblast.oblast}'"
      #намира всички общини към дадена област,
      #като първите 3 знака на полето obshtina идентифицират областа

      obshtini.each do |obshtina| #цикли намерените общини към областа
        municipality = district.municipalities.create({:name => obshtina.name}) #създава общини в постоянната таблица
        puts "Записана община : #{municipality.name}"

        places = Ekatte.find_by_sql "SELECT * FROM ekattes WHERE municipality  = ('#{obshtina.obshtina}')" #намира всички градове на общината

        puts "'#{obshtina.obshtina}'"
        places.each do |place| #цикли градове и села които са намерени за общината
          city = municipality.cities.create(:name => place.name, :place_type => place.place_type, :district_id => municipality.district.id, :kind => place.kind, :ekatte => place.ekatte) #създава градове и села в постоянната таблица
          puts "Записан град : #{city.name}"
        end

      end
    end

    puts "Изтриване на времените таблици"
    CreateOblasti.drop
    CreateObshtini.drop
    CreateEkatte.drop

  end

  #дефиниране на моделите за времените таблици
  class Ekatte < ActiveRecord::Base

  end

  class Oblast < ActiveRecord::Base
    set_table_name "oblasti"
  end

  class Obshtina < ActiveRecord::Base
    set_table_name "obshtini"
  end

  #миграция за областите във времената таблица
  class CreateOblasti < ActiveRecord::Migration
    def self.create
      drop if table_exists?(:oblasti)

      puts "Временна таблица за области - oblasti"
      create_table :oblasti do |t|
        t.string :oblast
        t.integer :ekatte
        t.string :name        
      end

      add_index :oblasti, [:oblast, :ekatte]
      puts "Прочитане на csv файла ek_obl.csv"
      self.read_data

    end

    def self.drop
      drop_table :oblasti
    end

  private

    #чете csv факла и записва във времента таблица
    def self.read_data
      begin
        file  = File.join(RAILS_ROOT, 'db', 'ek_obl.csv')
        rise FileNotFound unless File.exist?(file)
        CSV.open(file,'r') do |row|
           Oblast.create({:oblast => row[0], :ekatte => row[1].to_i, :name => row[2]})
        end
      rescue FileNotFound
        puts "Файлът ek_obl.csv не беше намерен"
      rescue
        self.drop
        rise
      end
    end

  end

  #миграция за общините във времената таблица
  class CreateObshtini < ActiveRecord::Migration
    def self.create
      drop if table_exists?(:obshtini)

      puts "Временна таблица за общини - obshtini"
      create_table :obshtini do |t|
        t.string :obshtina
        t.integer :ekatte
        t.string :name
      end

      add_index :obshtini, [:obshtina, :ekatte]
      puts "Прочитане на csv файла ek_obst.csv"
      self.read_data

    end

    def self.drop
      drop_table :obshtini
    end

  private

    #чете csv факла и записва във времента таблица
    def self.read_data
      begin
        file  = File.join(RAILS_ROOT, 'db', 'ek_obst.csv')
        rise FileNotFound unless File.exist?(file)
        CSV.open(file,'r') do |row|
           Obshtina.create({:obshtina => row[0], :ekatte => row[1].to_i, :name => row[2]})
        end
      rescue FileNotFound
        puts "Файлът ek_obst.csv не беше намерен"
      rescue
        self.drop
        rise
      end
    end

  end

  #миграция за общините във времената таблица
  class CreateEkatte < ActiveRecord::Migration
    def self.create
      drop if table_exists?(:ekattes)

      puts "Временна таблица за градове и села - ekattes"
      create_table :ekattes do |t|
        t.integer :ekatte
        t.string :place_type
        t.string :name
        t.string :district
        t.string :municipality
        t.integer :kind
      end

      add_index :ekattes, [:ekatte, :district, :municipality]
      puts "Прочитане на csv файла ek_atte.csv"
      self.read_data

    end

    def self.drop
      drop_table :ekattes
    end

  private

    #чете csv факла и записва във времента таблица
    def self.read_data
      begin
        file  = File.join(RAILS_ROOT, 'db', 'ek_atte.csv')
        rise unless File.exist?(file)
        CSV.open(file,'r') do |row|
           Ekatte.create({:ekatte => row[0].to_i, :place_type => (type = row[1].to_s), :name => row[2], :district => row[3], :municipality => row[4], :kind => row[6].to_i})
        end
      rescue
        self.drop
        rise
      end
    end

  end
  
end