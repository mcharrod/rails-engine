class Item < ApplicationRecord
  belongs_to :merchant

  validates :unit_price, numericality: true
  validates_presence_of :name
  validates_presence_of :description
end
