class Cart
  include ActionView::Helpers::NumberHelper
  attr_reader :contents

  def initialize(contents)
    @contents = contents || Hash.new(0)
  end

  def total_count
    @contents.values.sum
  end

  def cart_items
    result = {}
    @contents.each do |id, quantity|
      item = Item.find(id)
      result[item] = quantity
    end
    result
  end

  def sub_total(item)
    quantity = cart_items[item]

    quantity * item.price.to_f
  end

  def grand_total
    cart_items.sum do |item, quantity|
      item.price * quantity
    end.to_f
  end

  def delete_item(item_id)
   @contents.delete(item_id)
  end

  def clear_cart
    @contents.clear
  end

  def associate_items(order)
    @contents.each do |item_id, quantity|
      item = Item.find(item_id)
      OrderItem.create(item: item, order: order, quantity: quantity, price: item.price, fulfilled: false)
    end
  end

end
