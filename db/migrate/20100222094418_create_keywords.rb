class CreateKeywords < ActiveRecord::Migration
  def self.up
    create_table :keywords do |t|
      t.string :tag, :uniq => true
      t.string :patern
      t.string :as
      t.boolean :active
      t.string  :validation_method
      t.integer :values
      t.string  :kind_of_search
      t.timestamps
    end

    Keyword.create_translation_table! :name => :string
    add_index(:keywords, :tag)
  end
  
  def self.down
    drop_table :keywords
    Keyword.drop_translation_table!
  end

end
