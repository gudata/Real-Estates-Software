# == Schema Information
#
# Table name: offer_types
#
#  id                    :integer(4)      not null, primary key
#  position              :integer(4)
#  active                :boolean(1)
#  category              :integer(4)
#  tag                   :string(255)
#  oposite_offer_type_id :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#

class OfferType < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10
  translates :name

  default_scope :include => :translations

  belongs_to :oposite_offer_type, :class_name => "OfferType"

  BUY_TYPE = 1
  SELL_TYPE = 2

  scope :buy_type, where(:category => BUY_TYPE)
  scope :sell_type, where(:category => SELL_TYPE)

  has_one :buy if :category == BUY_TYPE
  has_one :sell if :category == SELL_TYPE

  def self.for tag
    OfferType.find_by_tag(sym_to_tag(tag))
  end

  def sym_to_tag tag
    OfferType.sym_to_tag tag
  end

  def self.sym_to_tag sym
    {
      :buyers => "buyers",
      :letters => "letters",
      :sellers => "sellers",
      :renters => "renters",
    }[sym]
  end

end
