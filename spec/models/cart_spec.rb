require 'rails_helper'

RSpec.describe Cart do

  describe '#total_count' do
    it 'calculates number item in cart' do
      cart = Cart.new(
        {
          "1": 2,
          "2": 3
          })

      expect(cart.total_count).to eq(5)
    end
  end
end
