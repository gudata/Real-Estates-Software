# == Schema Information
#
# Table name: keywords_validation_types
#
#  keyword_id         :integer(4)
#  validation_type_id :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

class KeywordsValidationTypes < ActiveRecord::Base
  belongs_to :keyword
  belongs_to :validation_type
end
