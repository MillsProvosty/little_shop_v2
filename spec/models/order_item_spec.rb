require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "validations" do
    it {should validate_numericality_of :quantity}
    it {should validate_numericality_of :price}
#    it {should validate_presence_of :fulfilled}
  end

  describe "relationships" do
    it {should belong_to :order}
    it {should belong_to :item}
  end

  describe "class methods" do
    it ".find_row_by(order_id, item_id)" do
      item = create(:item)
      order = create(:order)
      orderitem = create(:order_item, item: item, order: order)

      expect(OrderItem.find_row_by(order.id, item.id)).to eq(orderitem)
    end
  end
end
