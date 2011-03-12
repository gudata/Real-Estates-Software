class CreateContactCategories < ActiveRecord::Migration
  def self.up
    create_table :contact_categories do |t|
      t.boolean :active
      t.integer :position
    end

    ContactCategory.create_translation_table! :name => :string
    add_index(:contact_categories, :position)
  end

  def self.down
    drop_table :contact_categories
    remove_index(:contact_categories, :position)
    ContactCategory.drop_translation_table!
  end
end
