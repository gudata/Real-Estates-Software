class CreateKeywordsPropertyTypes < ActiveRecord::Migration
  def self.up
    create_table :keywords_property_types do |t|
      t.integer :property_type_id
      t.integer :keyword_id
      t.integer :position, :default => 0
      t.boolean :end_of_line, :default => false
      t.string :style
      t.timestamps
    end

    add_index(:keywords_property_types, :keyword_id)
    add_index(:keywords_property_types, :property_type_id)
    add_index(:keywords_property_types, :position)
  end

  def self.down
    remove_index(:keywords_property_types, :keyword_id)
    remove_index(:keywords_property_types, :property_type_id)
    remove_index(:keywords_property_types, :position)
    drop_table :keywords_property_types
  end
end
