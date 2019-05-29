class Item < ApplicationRecord
  validates_presence_of :name, :description, :image
  validates_numericality_of :price, :greater_than => 0
  validates_numericality_of :inventory, :greater_than => 0

  validates_inclusion_of :active, in: [true, false]
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items, dependent: :destroy

  def self.active_items
    Item.where(active: true)
  end

  def self.top_five
    joins(:order_items)
    .where("order_items.fulfilled IS true")
    .select("Items.*, sum(order_items.quantity) AS total_quantity")
    .group(:id).order("total_quantity desc").limit(5)
  end

  def self.bottom_five
    joins(:order_items)
    .where("order_items.fulfilled IS true")
    .select("Items.*, sum(order_items.quantity) AS total_quantity")
    .group(:id).order("total_quantity asc").limit(5)
  end

  def quantity_bought
    order_items.where(fulfilled: :true).sum(:quantity)
  end


  def avg_fulfill_time
    order_items.average("order_items.updated_at - order_items.created_at").to_i * 24
  end


  def quantity_on_order(order_id)
    order_items.find_by(order_id: order_id).quantity
  end

  def item_subtotal
    order_items.sum("order_items.price * order_items.quantity")
  end

  def percentage_remaining
      quantity_bought/inventory.to_f * 100
  end

end
