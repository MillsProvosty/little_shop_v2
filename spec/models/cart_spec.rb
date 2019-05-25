require 'rails_helper'

RSpec.describe Cart do

  before :each do
    @item_1, @item_2 = create_list(:item, 2)

    @cart = Cart.new(
      {
        @item_1.id.to_s => 2,
        @item_2.id.to_s => 3
      })

  end
  describe '#total_count' do
    it 'calculates number item in cart' do
      expect(@cart.total_count).to eq(5)
    end
  end

  describe '#cart_items' do
    it 'returns has with items as key and quantity as value' do
      expected = {
        @item_1 => 2,
        @item_2 => 3
      }

      expect(@cart.cart_items).to eq(expected)
    end
  end

  describe '#sub_total' do
    it 'returns subtotals of a particular item depending on quantity of that item' do
      quantity = @cart.contents[@item_1.id.to_s]

      expect(@cart.sub_total(@item_1)).to eq(quantity * @item_1.price)
    end
  end

  describe '#grand_total' do
    it 'returns grandtotal of all items in cart' do

      expected = @cart.cart_items.sum { |item, quantity| item.price.to_f * quantity }

      expect(@cart.grand_total).to eq(expected)
    end
  end

  describe '#delete_item' do
    it 'deletes an item' do

      expected = {
        @item_2.id.to_s => 3
      }
      @cart.delete_item(@item_1.id.to_s)

      expect(@cart.contents).to eq(expected)
    end
  end
end
