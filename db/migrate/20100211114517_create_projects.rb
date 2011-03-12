class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.belongs_to :contact
      t.belongs_to :status
      t.belongs_to :source
      t.integer :source_value
      t.string :reference_point
      t.belongs_to :property_category_location
      t.belongs_to :user
      t.belongs_to :team
      t.string :contact_person
      t.string :contact_person_phone
      t.belongs_to :address
      t.belongs_to :furnish
      t.string :website
      t.date :start_date
      t.date :finish_date
      t.float :managment_fee
      t.float :discount
      t.float :brokerage
      t.text :description
      t.text :additional_description
      t.boolean :active
      t.integer :project_stage_id
      t.timestamps
    end

    Project.create_translation_table! :name => :string,
      :description => :string, :aditional_description => :string, :reference_point => :string
    add_index(:projects, :address_id)
    add_index(:projects, :user_id)
    add_index(:projects, :contact_id)
  end
  
  def self.down
    drop_table :projects
    remove_index(:projects, :address_id)
    remove_index(:projects, :user_id)
    remove_index(:projects, :contact_id)
    Project.drop_translation_table!
  end
end
