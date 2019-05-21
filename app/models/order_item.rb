class OrderItem < ApplicationRecord
  belongs_to :item
  belongs_to :order

  validates_numericality_of :quantity, :price
  validates_presence_of :fulfilled
end
