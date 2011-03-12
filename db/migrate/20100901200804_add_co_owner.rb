class AddCoOwner < ActiveRecord::Migration
  def self.up
    add_column :sells, :co_owner_id, :integer
    add_column :sells, :valid_to, :date
    add_column :sells, :canceled_until, :date
    add_column :sells, :canceled_type_id, :integer
    #    add_column :sells, :permit_building_at, :date
    #    add_column :sells, :permit_using_at, :date
    
    add_index(:sells, :co_owner_id)

    add_column :addresses, :building, :string
    add_column :addresses, :floor_type_id, :string, :limit => 25
    add_column :addresses, :street_type_id, :string, :limit => 25
    add_column :addresses, :description, :text

    Address.create_translation_table! :description => :text
#    City.create_translation_table! :place_type => :text
  
    floors = {}
    FloorType.all.each do |floor|
      floors[floor.value.to_i] = floor.id
    end
    
    Address.find_each do |address|
      floor = address.floor
      address.floor_type_id = floors[floor.to_i] if address.floor_type_id.blank? and !floor.blank?
      address.save
    end.reject{|c| true}

    SellDocument.all do |sell_document|
      floor = sell_document.address_document.floor
      sell_document.address_document.floor_type_id = floors[floor.to_i] if sell_document.address_document.floor_type_id.blank? !floor.blank?
      sell_document.save
    end.reject{|c| true}

    

    Buy.all.each do |buy|
      buy.search_criterias.each do |search_criteria|
        search_criteria.save
      end
    end
    
    # fix the i18n

    # Add those to the database

    [
      {:position => 0, :active => true, :name => "Изтекла"},
      {:position => 1, :active => true, :name => "Спряна"},
      {:position => 2, :active => true, :name => "Продадена"},
    ].each {|canceled_type| CanceledType.create(canceled_type)} if CanceledType.count == 0

    [
      {:position => 0, :active => true, :value => 0, :name => "Улица"},
      {:position => 1, :active => true, :value => 1, :name => "Булевард"},
      {:position => 2, :active => true, :value => 2, :name => "Алея"},
    ].each { |street| StreetType.create(street) } if StreetType.count == 0

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
    ].each {|floor| FloorType.create(floor)} if FloorType.count == 0


    City.find_each do |city|
      if city.kind == 1
        city.place_type = "гр."
      else
        city.place_type = "с."
      end
    end

    puts "check utils/fix_localization.rb"
    # street_types, canceled_types, floor_types
  end

  def self.down
    remove_column :sells, :co_owner_id
    remove_column :sells, :valid_to
    remove_column :sells, :canceled_until
    remove_column :sells, :canceled_type_id
    #    remove_column :sells, :permit_building_at
    #    remove_column :sells, :permit_using_at


    remove_column :addresses, :building
    remove_column :addresses, :description
    remove_column :addresses, :floor_type_id
    remove_column :addresses, :street_type_id
  end
end