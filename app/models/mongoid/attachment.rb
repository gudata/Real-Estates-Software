require 'app/uploaders/attachment_uploader'
#require 'carrierwave/orm/mongoid'

class Attachment
  include Mongoid::Document
  include Mongoid::I18n
  include Mongoid::ActiverecordPatch
  include Mongoid::Timestamps
  
  localized_field :name
  localized_field :description

  embedded_in :folder, :class_name => 'Buy', :inverse_of => :attachments

  referenced_in :user, :index => true

  mount_uploader :attachment, AttachmentUploader

  #  validates_attachment_presence :document
  #  validates_attachment_size :document, :less_than => 20.megabytes, :greater_than => 90
end
