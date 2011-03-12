class CreateAbilities < ActiveRecord::Migration
  def self.up
    create_table :abilities do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :abilities
  end
end
