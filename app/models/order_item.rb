class OrderItem < ApplicationRecord
  belongs_to :item
  belongs_to :order

  validates_numericality_of :quantity, :price
  validates_inclusion_of :fulfilled, in: [true, false]

  def self.find_row_by(order_id, item_id)
    find_by(item_id: item_id, order_id: order_id)
  end
end
