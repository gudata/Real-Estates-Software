class FixCanceledTypeId < ActiveRecord::Migration
  def self.up
    remove_column :sells, :canceled_type_id
    add_column :sells, :canceled_type_id, :string
  end

  def self.down
    remove_column :sells, :canceled_type_id
    add_column :sells, :canceled_type_id, :integer
  end
end
