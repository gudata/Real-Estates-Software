class AddContactUserFlags < ActiveRecord::Migration
  def self.up
    # За текущият потребител
    #   активни
    #   всички
    # за всички потребители
    #   активни
    #   всички
    add_column :contacts_users, :letters_count, :integer, :default => 0
    add_column :contacts_users, :sell_count, :integer, :default => 0
    add_column :contacts_users, :buy_count, :integer, :default => 0
    add_column :contacts_users, :rent_count, :integer, :default => 0

    add_column :contacts_users, :letters_count_active, :integer, :default => 0
    add_column :contacts_users, :sell_count_active, :integer, :default => 0
    add_column :contacts_users, :buy_count_active, :integer, :default => 0
    add_column :contacts_users, :rent_count_active, :integer, :default => 0

    add_column :contacts, :letters_count, :integer, :default => 0
    add_column :contacts, :sell_count, :integer, :default => 0
    add_column :contacts, :buy_count, :integer, :default => 0
    add_column :contacts, :rent_count, :integer, :default => 0

    add_column :contacts, :letters_count_active, :integer, :default => 0
    add_column :contacts, :sell_count_active, :integer, :default => 0
    add_column :contacts, :buy_count_active, :integer, :default => 0
    add_column :contacts, :rent_count_active, :integer, :default => 0

    Sell.all.each{|sell| sell.save}
    Buy.all.each{|buy| buy.save}
  end

  def self.down
    remove_column :contacts_users, :letters_count_active
    remove_column :contacts_users, :sell_count_active
    remove_column :contacts_users, :buy_count_active
    remove_column :contacts_users, :rent_count_active

    remove_column :contacts, :letters_count_active
    remove_column :contacts, :sell_count_active
    remove_column :contacts, :buy_count_active
    remove_column :contacts, :rent_count_active
    
    remove_column :contacts_users, :letters_count
    remove_column :contacts_users, :sell_count
    remove_column :contacts_users, :buy_count
    remove_column :contacts_users, :rent_count

    remove_column :contacts, :letters_count
    remove_column :contacts, :sell_count
    remove_column :contacts, :buy_count
    remove_column :contacts, :rent_count
  end
end