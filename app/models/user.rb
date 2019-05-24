class User < ApplicationRecord
  has_secure_password
  validates_presence_of :role, :email, :password, :name, :address, :city,
                        :state, :zip

  validates_inclusion_of :active, in: [true, false]

  validates_uniqueness_of :email

#  validates_numericality_of :role
  enum role: %w[user merchant admin]
  has_many :items
  has_many :orders

  def top_items_for_merchant
    items
    .joins(:orders)
    .select("items.*, sum(order_items.quantity) AS total_sold")
    .where("orders.status = 2")
    .group("items.id")
    .order("total_sold desc")
    .limit(5)
  end

  def all_orders
    Order.joins(:items).where("items.user_id =#{id} and orders.status =0").distinct
  end

end
