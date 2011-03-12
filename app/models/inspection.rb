# == Schema Information
#
# Table name: inspections
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)
#  sell_id          :integer(4)
#  sell_document_id :string(255)
#  buy_id           :string(255)
#  description      :text
#  inspectable_type :string(255)
#  inspectable_id   :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

class Inspection < ActiveRecord::Base
  translates  :name, :description

  belongs_to :inspectable, :polymorphic => true
  belongs_to :user

  belongs_to :visit_user, :class_name => "User", :foreign_key => "visit_user_id"
  belongs_to :first_visit_with_user, :class_name => "User", :foreign_key => "first_visit_with_user_id"
  belongs_to :second_visit_with_user, :class_name => "User", :foreign_key => "second_visit_with_user_id"
  belongs_to :third_visit_with_user, :class_name => "User", :foreign_key => "third_visit_with_user_id"
  belongs_to :forth_visit_with_user, :class_name => "User", :foreign_key => "forth_visit_with_user_id"
  belongs_to :fifth_visit_with_user, :class_name => "User", :foreign_key => "fifth_visit_with_user_id"
#  validates_associated :user
  default_scope :include => :translations
end
