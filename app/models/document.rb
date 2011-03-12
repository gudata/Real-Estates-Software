# == Schema Information
#
# Table name: documents
#
#  id                    :integer(4)      not null, primary key
#  name                  :string(255)
#  description           :string(255)
#  document_file_name    :string(255)
#  document_content_type :string(255)
#  document_file_size    :string(255)
#  attachable_type       :string(255)
#  attachable_id         :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#

class Document < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  translates  :name, :description
  
  has_attached_file :document, :storage => :filesystem

  validates_attachment_presence :document
#  validates_attachment_size :document, :less_than => 20.megabytes, :greater_than => 90

  default_scope :include => :translations
end
