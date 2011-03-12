class CreateKeywordsSells < ActiveRecord::Migration
  def self.up
    create_table :keywords_sells do |t|
      t.integer :sell_id
      t.integer :keyword_id
      t.string :value
      t.string :patern
      t.timestamps
    end

    add_index(:keywords_sells, :sell_id)
    add_index(:keywords_sells, :keyword_id)
  end

  def self.down
    remove_index(:keywords_sells, :sell_id)
    remove_index(:keywords_sells, :keyword_id)
    drop_table :keywords_sells
  end
end
