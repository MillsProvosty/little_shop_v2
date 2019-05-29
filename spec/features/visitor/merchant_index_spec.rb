require 'rails_helper'


RSpec.describe "As a visitor on the merchants index page" do
  before :each do
    @user = create(:user)

    @merch1 = create(:merchant)
    @merch2 = create(:merchant)
    @merch3 = create(:merchant)
    @merch4 = create(:merchant)

    @buyer1 = create(:user, city: "Denver", state: "Colorado")
    @buyer2 = create(:user, city: "Truth and Consequences", state: "Arizona")
    @buyer3 = create(:user, city: "God Knows Where", state: "Alaska")
    @buyer4 = create(:user, city: "God Knows Where", state: "Texas")

    @o1 = create(:order, created_at: 1.days.ago, updated_at: 1.hours.ago, status: "shipped", user: @buyer1)
    @o2 = create(:order, created_at: 2.days.ago, updated_at: 1.days.ago, status: "cancelled", user: @buyer2)
    @o3 = create(:order, created_at: 3.days.ago, updated_at: 3.hours.ago, status: "shipped", user: @buyer3)
    @o4 = create(:order, created_at: 10.days.ago, updated_at: 2,hours.ago, status: "shipped", user: @buyer4)
    @o5 = create(:order, created_at: 5.days.ago, updated_at: 4.days.ago, status: "cancelled", user: @buyer1)
    @o6 = create(:order, created_at: 3.days.ago, updated_at: 2.hours.ago, status: "shipped", user: @buyer1)
    @o7 = create(:order, created_at: 20.days.ago, updated_at: 15.days.ago, status: "shipped", user: @buyer1)
    @o8 = create(:order, created_at: 4.days.ago, updated_at: 3.days.ago, status: "pending", user: @buyer2)
    @o9 = create(:order, created_at: 18.days.ago, updated_at: 1.hours.ago, status: "pending", user: @buyer2)

    @i1 = create(:item, price: 100, user: @merch1)
    @i2 = create(:item, price: 50, user: @merch2)
    @i3 = create(:item, price: 20, user: @merch3)

    @oi = create(:order_items, price: 100, quantity: 2, order: @o1, fulfilled: true, item: @i1)
    @oi = create(:order_items, price: 100, quantity: 1, order: @o2, fulfilled: true, item: @i1)
    @oi = create(:order_items, price: 300, quantity: 3, order: @o3, fulfilled: true, item: @i1)
    @oi = create(:order_items, price: 400, quantity: 10, order: @o4, fulfilled: true, item: @i2)
    @oi = create(:order_items, price: 500, quantity: 2, order: @o5, fulfilled: true, item: @i2)
    @oi = create(:order_items, price: 600, quantity: 3, order: @o6, fulfilled: true, item: @i2)
    @oi = create(:order_items, price: 700, quantity: 10, order: @o7, fulfilled: true, item: @i3)
    @oi = create(:order_items, price: 800, quantity: 1, order: @o8, fulfilled: true, item: @i3)
    @oi = create(:order_items, price: 900, quantity: 5, order: @o9, fulfilled: true, item: @i3)
    @oi = create(:order_items, price: 100, quantity: 1, order: @o2, fulfilled: false, item: @i1)
    @oi = create(:order_items, price: 1900, quantity: 5, order: @o3, fulfilled: false, item: @i1)
    @oi = create(:order_items, price: 400, quantity: 4, order: @o4, fulfilled: false, item: @i2)
    @oi = create(:order_items, price: 700, quantity: 7, order: @o5, fulfilled: false, item: @i2)
    @oi = create(:order_items, price: 800, quantity: 2, order: @o6, fulfilled: false, item: @i3)
    @oi = create(:order_items, price: 100000, quantity: 1 , order: @o7, fulfilled: false, item: @i3)


  end

  describe "I see an area with the following statistics" do
    it "top 3 merchants who have sold the most by price and quantity, and their revenue " do
    end

    xit "top 3 merchants who were fastest at fulfilling items in an order, and their times" do
    end

    xit "worst 3 merchants who were slowest at fulfilling items in an order, and their times" do
    end

    xit "top 3 states where any orders were shipped (by number of orders), and count of orders" do
    end

    xit "top 3 cities where any orders were shipped (by number of orders, also Springfield, MI should not be grouped with Springfield, CO), and the count of orders" do
    end

    xit "top 3 biggest orders by quantity of items shipped in an order, plus their quantities" do
    end
  end
end
