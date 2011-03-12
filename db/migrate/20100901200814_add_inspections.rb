class AddInspections < ActiveRecord::Migration
  def self.up
    add_column :inspections, :visit_user_id, :integer
    add_column :inspections, :first_visit_with_user_id, :integer
    add_column :inspections, :second_visit_with_user_id, :integer
    add_column :inspections, :third_visit_with_user_id, :integer
    add_column :inspections, :forth_visit_with_user_id, :integer
    add_column :inspections, :fifth_visit_with_user_id, :integer
  end

  def self.down
    remove_column :inspections, :visit_user_id
    remove_column :inspections, :first_visit_with_user_id
    remove_column :inspections, :second_visit_with_user_id
    remove_column :inspections, :third_visit_with_user_id
    remove_column :inspections, :forth_visit_with_user_id
    remove_column :inspections, :fifth_visit_with_user_id
  end
end