class OrderItem < ApplicationRecord
  belongs_to :item
  belongs_to :order

  validates_numericality_of :quantity, :price
  validates_inclusion_of :fulfilled, in: [true, false]

  def time_difference
    ((updated_at - created_at) / 60 / 60 / 24)
  end
end
