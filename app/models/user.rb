class User < ApplicationRecord
  has_secure_password
  validates_presence_of :role, :email, :password, :name, :address, :city,
                        :state, :zip

  validates_inclusion_of :active, in: [true, false]

  validates_uniqueness_of :email

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

  def pending_orders
    Order.joins(:items).where("items.user_id =#{id} and orders.status =0").distinct
  end

  def date_registered
    created_at.strftime("%B %d, %Y")
  end

  def self.active_merchants
    where(role: :merchant, active: true).order(name: :asc)
  end

  def self.reg_users
    where(role: "user")
  end

  def top_three_states
    items.joins(:orders)
    .where("orders.status = 2")
    .select("SUM(order_items.quantity) AS qty, users.state")
    .joins("join users on orders.user_id = users.id")
    .group("users.state")
    .order("qty DESC")
    .limit(3)
  end

  def top_three_cities
    items.joins(:orders)
      .where("orders.status = 2")
      .select("SUM(order_items.quantity) AS qty, users.state, users.city")
      .joins("join users on orders.user_id = users.id")
      .group("users.state, users.city")
      .order("qty DESC")
      .limit(3)
  end

  def top_customer
    items.joins(:orders).where("orders.status = 2").select("users.name, count(distinct(orders.id)) as order_num").joins("join users on users.id = orders.user_id").group("users.name").order("order_num")
  end


  def disable_items
    items.each do |item|
      item.update_column(:active, false)
    end
  end

  def self.topthreesellers
    User.where(role: :merchant)
    .joins(:items)
    .joins("join order_items on items.id = order_items.item_id")
    .select("distinct(users.name) AS name, SUM(order_items.price * order_items.quantity) AS revenue")
    .where("order_items.fulfilled = true")
    .group(:name)
    .limit(3)
    .reverse
  end

  def self.topthreetimes
   User.where(role: :merchant)
   .joins(:items)
   .joins("join order_items on items.id = order_items.item_id")
   .where("order_items.fulfilled = true")
   .select("AVG(order_items.updated_at - order_items.created_at) as time, users.id, users.name")
   .order(:time)
   .group(:id)
   .limit(3)
  end

  def self.worstthreetimes
    User.where(role: :merchant)
    .joins(:items)
    .joins("join order_items on items.id = order_items.item_id")
    .where("order_items.fulfilled = true")
    .select("AVG(order_items.updated_at - order_items.created_at) as time, users.id, users.name")
    .order(:time)
    .group(:id)
    .limit(3)
    .reverse
  end

  def self.topthreestates
    User.joins(:orders)
    .where("orders.status = 2")
    .select("users.state, COUNT(users.id) as order_count")
    .group("users.id")
  end

end
