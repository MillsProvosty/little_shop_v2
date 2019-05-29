class Order < ApplicationRecord

  enum status: [:pending, :packaged, :shipped, :cancelled]

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items, dependent: :destroy


  def item_quantity
    order_items.sum :quantity
  end

  def items_total_value
    order_items.sum { | o_i| o_i.price * o_i.quantity }
  end

  def items_from_merchant(merchant_id)
    items.where(user_id: merchant_id)
    .select("order_items.fulfilled, items.*, order_items.quantity")
  end

  def item_count_for_merchant(merchant_id)
    items_from_merchant(merchant_id).sum do |item|
      item.order_items.find_by(order_id: id).quantity
    end
  end

  def item_total_value_for_merchant(merchant_id)
    items_from_merchant(merchant_id).sum do |item|
      order_item = item.order_items.find_by(order_id: id)
      order_item.price * order_item.quantity
    end
  end

  def self.sort_by_status
    order(Arel.sql("status = 1")).reverse
  end
end
