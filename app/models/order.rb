class Order < ApplicationRecord

  enum status: [:pending, :packaged, :shipped, :cancelled]
  #validates_numericality_of :status

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items


  def item_quantity
    items.count
  end

  def items_total_value
    items.sum(:price)
  end

end
