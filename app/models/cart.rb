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
    cart_items[item] * item.price.to_f
  end

  def grand_total
    cart_items.sum do |item, quantity|
      item.price * quantity
    end.to_f
  end

  def delete_item(item_id)
   @contents.delete(item_id)
  end

end
