class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates_numericality_of :quantity, :price
#  validates_presence_of :fulfilled
  validates_inclusion_of :fulfilled, in: [true, false]
end
