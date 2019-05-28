require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe "When a registered User visits Profile Orders Page" do
  before :each do
    @user = create(:user)

    @order_1 = create(:order, user: @user)
      @item_1 = create(:item)
      @item_2 = create(:item)
      @item_3 = create(:item)
        @o1_oi1 = create(:order_item, order: @order_1, item: @item_1)
        @o1_oi2 = create(:order_item, order: @order_1, item: @item_2)
        @o1_oi3 = create(:order_item, order: @order_1, item: @item_3)
        @o1_oi4 = create(:order_item, order: @order_1, item: @item_3)
        @o1_oi5 = create(:order_item, order: @order_1, item: @item_3)

    @order_2 = create(:packaged_order, user: @user)
      @item_4 = create(:item)
      @item_5 = create(:item)
      @item_6 = create(:item)
        @o2_oi1 = create(:order_item, order: @order_2, item: @item_4)
        @o2_oi2 = create(:order_item, order: @order_2, item: @item_5)
        @o2_oi3 = create(:order_item, order: @order_2, item: @item_6)

    @order_3 = create(:shipped_order, user: @user)
      @item_7 = create(:item)
      @item_8 = create(:item)
      @item_9 = create(:item)
        @o3_oi1 = create(:order_item, order: @order_3, item: @item_7)
        @o3_oi2 = create(:order_item, order: @order_3, item: @item_8)
        @o3_oi3 = create(:order_item, order: @order_3, item: @item_9)

    @order_4 = create(:cancelled_order, user: @user)
      @item_10 = create(:item)
      @item_11 = create(:item)
      @item_12 = create(:item)
        @o4_oi1 = create(:order_item, order: @order_4, item: @item_10)
        @o4_oi2 = create(:order_item, order: @order_4, item: @item_11)
        @o4_oi3 = create(:order_item, order: @order_4, item: @item_12)

  end

  it "I see the ID of the order, date created and updated, status, item quantity, grand total" do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit user_orders_path

    within("#order-#{@order_1.id}") do
      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content(@order_1.updated_at)
      expect(page).to have_content(@order_1.status)
      expect(page).to have_content(@order_1.item_quantity)
      expect(page).to have_content(number_to_currency @order_1.items_total_value)
    end

    within("#order-#{@order_2.id}") do
      expect(page).to have_content(@order_2.id)
      expect(page).to have_content(@order_2.created_at)
      expect(page).to have_content(@order_2.updated_at)
      expect(page).to have_content(@order_2.status)
      expect(page).to have_content(@order_2.item_quantity)
      expect(page).to have_content(number_to_currency @order_2.items_total_value)
    end

    within("#order-#{@order_3.id}") do
      expect(page).to have_content(@order_3.id)
      expect(page).to have_content(@order_3.created_at)
      expect(page).to have_content(@order_3.updated_at)
      expect(page).to have_content(@order_3.status)
      expect(page).to have_content(@order_3.item_quantity)
      expect(page).to have_content(number_to_currency(@order_3.items_total_value))
    end

    within("#order-#{@order_4.id}") do
      expect(page).to have_content(@order_4.id)
      expect(page).to have_content(@order_4.created_at)
      expect(page).to have_content(@order_4.updated_at)
      expect(page).to have_content(@order_4.status)
      expect(page).to have_content(@order_4.item_quantity)
      expect(page).to have_content(number_to_currency @order_4.items_total_value)
    end
    within("#order-#{@user.orders.last.id}") do
      expect(page).to have_content(@user.orders.last.id)
      expect(page).to have_content(@user.orders.last.created_at)
      expect(page).to have_content(@user.orders.last.updated_at)
      expect(page).to have_content(@user.orders.last.status)
      expect(page).to have_content(@user.orders.last.item_quantity)
      expect(page).to have_content(number_to_currency @user.orders.last.items_total_value)
    end
  end

describe "when I visit an orders show page " do
  it "if order still pending, I see button to cancel the order" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit user_orders_path

    within("#order-#{@order_1.id}") do
      expect(page).to have_button("Cancel Order")
    end

    within("#order-#{@order_2.id}") do
      expect(page).to_not have_button("Cancel Order")
    end
  
    within("#order-#{@order_3.id}") do
      expect(page).to_not have_button("Cancel Order")
    end
  end

    it "each row in order item is given status of unfulfilled, order is given status cancel" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit user_orders_path

    within("#order-#{@order_1.id}") do
      click_button "Cancel Order"
    end

    @order_1.reload

    expect(@order_1.status).to eq("cancelled")
    expect(@o1_oi1.fulfilled).to eq(false)
    expect(@o1_oi2.fulfilled).to eq(false)
    expect(@o1_oi3.fulfilled).to eq(false)
  end

    it "shows each item I ordered and all information about those items" do
      user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      order_1 = create(:order, user: user)
        item_1 = create(:item)
        item_2 = create(:item)
        item_3 = create(:item)
          o1_oi1 = create(:order_item, order: order_1, item: item_1)
          o1_oi2 = create(:order_item, order: order_1, item: item_2)
          o1_oi3 = create(:order_item, order: order_1, item: item_3)
          o1_oi4 = create(:order_item, order: order_1, item: item_3)
          o1_oi5 = create(:order_item, order: order_1, item: item_3)
      visit user_orders_path

      within("#order-#{order_1.id}") do
        expect(page).to have_content(item_1.name)
        expect(page).to have_content(item_1.description)
        expect(page).to have_content(item_1.image)
        expect(page).to have_content(item_1.quantity_bought)
        expect(page).to have_content(item_1.price)
        expect(page).to have_content(item_3.item_subtotal)
      end
    end
  end
end
