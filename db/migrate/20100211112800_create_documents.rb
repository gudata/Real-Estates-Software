class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :name
      t.string :description
      t.string :document_file_name
      t.string :document_content_type
      t.string :document_file_size
      t.string :attachable_type
      t.integer :attachable_id
      t.timestamps
    end

    Document.create_translation_table! :name => :string, :description => :string
    add_index(:documents, [:attachable_type, :attachable_id])
  end
  
  def self.down
    drop_table :attachments
    remove_index(:documents, [:attachable_type, :attachable_id])
    Document.drop_translation_table!
  end
end