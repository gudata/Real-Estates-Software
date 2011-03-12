# == Schema Information
#
# Table name: keywords_sells
#
#  id         :integer(4)      not null, primary key
#  sell_id    :integer(4)
#  keyword_id :integer(4)
#  value      :string(255)
#  patern     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class KeywordsSell < ActiveRecord::Base

  validate :value, :presence => true, :if => Proc.new{|record|
    unless record.keyword.validation_type_ids.blank? || record.keyword.validation_types.include?("validates_presence_of")
      true
    end
  }
  validates_numericality_of :value,
    :if => Proc.new{|record|
    unless record.keyword.validation_type_ids.blank? || record.keyword.validation_types.include?("validates_numericality_of")
      true
    end
  }

  belongs_to :keyword
  belongs_to :sell

  before_save :cache_patern

  private
  def cache_patern
    self.patern = keyword.patern
  end
end
