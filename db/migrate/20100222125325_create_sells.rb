class CreateSells < ActiveRecord::Migration
  def self.up
    create_table :sells do |t|
      t.integer :user_id
      t.integer :client_id
      t.integer :offer_type_id
      t.integer :property_type_id
      t.integer :status_id
      t.integer :address_id
      t.integer :source_id
      t.string  :source_value      
      t.string  :mongo_document_id
      t.integer :property_category_location_id
      t.integer :project_id
      t.string  :project_building
      t.string  :project_entrance
      t.integer :project_floor
      t.string  :project_unit
      t.timestamps
    end

    Sell.create_translation_table! :description => :text
    add_index(:sells, :user_id)
    add_index(:sells, :client_id)
    add_index(:sells, :address_id)
    add_index(:sells, :property_type_id)
    add_index(:sells, :project_id)
  end
  
  def self.down
    remove_index(:sells, :user_id)
    remove_index(:sells, :client_id)
    remove_index(:sells, :address_id)
    remove_index(:sells, :property_type_id)
    remove_index(:sells, :project_id)
    drop_table :sells
    Sell.drop_translation_table!
  end
end
