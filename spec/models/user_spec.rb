require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password}
    it {should validate_presence_of :role}
#    it {should validate_presence_of :active}
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end

  describe "relationships" do
    it {should have_many :items}
  end

  describe "instance methods" do
    before :each do
      #orders are for users not merchants...maybe?
      @user = create(:merchant)
      @user_2 = create(:merchant)

      @order_2 = create(:order)
      @order_1 = create(:shipped_order, user: @user)
      @order_3 = create(:cancelled_order)
      @order_4 = create(:shipped_order)

      @item_1 = create(:item, user: @user)
      @item_2 = create(:item, user: @user)
      @item_3 = create(:item, user: @user)
      @item_4 = create(:item, user: @user)
      @item_5 = create(:item, user: @user)
      @item_6 = create(:item, user: @user)
      @item_7 = create(:item, user: @user)
      @item_8 = create(:item, user: @user)
      @item_9 = create(:item, user: @user_2)
      @item_10 = create(:item, user: @user_2)
      @item_11 = create(:item, user: @user_2)

      @oi_1 = create(:order_item, item: @item_1, order: @order_1, quantity: 3, fulfilled: true)
      @oi_2 = create(:order_item, item: @item_2, order: @order_1, quantity: 6, fulfilled: true)
      @oi_3 = create(:order_item, item: @item_3, order: @order_1, quantity: 6, fulfilled: true)
      @oi_4 = create(:order_item, item: @item_3, order: @order_4, quantity: 5, fulfilled: true)
      @oi_5 = create(:order_item, item: @item_4, order: @order_1, quantity: 7, fulfilled: true)
      @oi_6 = create(:order_item, item: @item_5, order: @order_1, quantity: 5, fulfilled: true)
      @oi_7 = create(:order_item, item: @item_6, order: @order_1, quantity: 10, fulfilled: true)
      @oi_8 = create(:order_item, item: @item_6, order: @order_2, quantity: 6, fulfilled: false)
      @oi_9 = create(:order_item, item: @item_7, order: @order_3, quantity: 13, fulfilled: true)
      @oi_10 = create(:order_item, item: @item_8, order: @order_2, quantity: 6, fulfilled: true)


    end
    it ".top_items_for_merchant" do

      expected = [@item_3, @item_6, @item_4, @item_2, @item_5]

      expect(@user.top_items_for_merchant).to eq(expected)
    end

    it '.all_orders' do
      expect(@user.pending_orders).to eq([@order_2])
    end


  end
end
