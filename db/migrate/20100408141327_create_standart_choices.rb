class CreateStandartChoices < ActiveRecord::Migration
  def self.up
    create_table :standart_choices do |t|
      t.integer :position
      t.boolean :active
      t.timestamps
    end

    StandartChoice.create_translation_table! :name => :string

  end
  
  def self.down
    StandartChoice.drop_translation_table!
    drop_table :standart_choices
  end
end
