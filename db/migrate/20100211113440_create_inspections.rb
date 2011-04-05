class CreateInspections < ActiveRecord::Migration
  def self.up
    create_table :inspections do |t|
      t.datetime :data
      t.belongs_to :user
      t.integer :sell_id
      t.string :sell_document_id
      t.string :buy_id
      t.text :description
      t.string :inspectable_type
      t.integer :inspectable_id
      t.timestamps
    end

    Inspection.create_translation_table! :name => :string, :description => :string
    add_index(:inspections, [:inspectable_type, :inspectable_id])
  end
  
  def self.down
    drop_table :inspections
    remove_index(:inspections, [:inspectable_type, :inspectable_id])
    Inspection.drop_translation_table!
  end
end
