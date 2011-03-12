class CreateOfferTypes < ActiveRecord::Migration
  def self.up
    create_table :offer_types do |t|
      t.integer :position
      t.boolean :active
      t.integer :category
      t.string  :tag
      t.integer :oposite_offer_type_id
      t.timestamps
    end

   OfferType.create_translation_table! :name => :string
   add_index(:offer_types, :category)
   add_index(:offer_types, :oposite_offer_type_id)
  end
  
  def self.down
    drop_table :offer_types
    OfferType.drop_translation_table!
    remove_index(:offer_types, :category)
    remove_index(:offer_types, :oposite_offer_type_id)
  end

end
