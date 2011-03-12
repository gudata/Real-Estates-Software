class CreateInfrastructureTypes < ActiveRecord::Migration
  def self.up
    create_table :infrastructure_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    InfrastructureType.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :infrastructure_types
    InfrastructureType.drop_translation_table!
  end
end
