class CreateInternetComunicatorTypes < ActiveRecord::Migration
  def self.up
    create_table :internet_comunicator_types do |t|
      t.boolean :active
      t.integer :position
      t.boolean :is_email
      t.timestamps
    end

    InternetComunicatorType.create_translation_table! :name => :string
  end

  def self.down
    drop_table :internet_comunicator_types
    InternetComunicatorType.drop_translation_table!
  end
  
end
