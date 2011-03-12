class CreateKeywordsValidationTypes < ActiveRecord::Migration
  def self.up
    create_table :keywords_validation_types,  :id => false do |t|
      t.integer :keyword_id
      t.integer :validation_type_id
      t.timestamps
    end

    add_index(:keywords_validation_types, :keyword_id)
    add_index(:keywords_validation_types, :validation_type_id)
  end

  def self.down
    remove_index(:keywords_validation_types, :keyword_id)
    remove_index(:keywords_validation_types, :validation_type_id)
  end
end
