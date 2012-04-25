# == Schema Information
#
# Table name: pictures
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)
#  description          :string(255)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :string(255)
#  imagable_type        :string(255)
#  imagable_id          :integer(4)
#  created_at           :datetime
#  updated_at           :datetime
#

class Picture < ActiveRecord::Base
  translates  :name, :description
  belongs_to :attachable, :polymorphic => true

  has_attached_file :picture,
    :storage => :filesystem,
    :default_style => :thumb,
    :styles => {
    :thumb => "130>x130",
    :small_thumb => "80>x80",
    :small => "300>x300",
    :normal  => "600>x600",
  }

  validates_attachment_presence :picture
#  validates_attachment_size :picture, :less_than => 20.megabytes, :greater_than => 90 #, :if => Proc.new{|attachment| !attachment.picture_file_name.blank? }

  validates_attachment_content_type :picture,
    :content_type => ['image/jpeg','image/pjpeg', 'image/x-png', 'image/gif', 'image/png'],
    :message => "Sorry, only jpg, png or gif image files are allowed"

  default_scope includes(:translations).order(:created_at => :desc)

  # За да работи полиморфизма се добавят тези методи
  def url(*args)
    picture.url(*args)
  end

  def file_name
    picture_file_name
  end

  def content_type
    picture_content_type
  end

  def file_size
    picture_file_size
  end


end
