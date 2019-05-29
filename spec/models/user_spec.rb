require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password}
    it {should validate_presence_of :role}
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
      @user = create(:user)
      @user_1 = create(:user)
      @user_2 = create(:user)
      @user_3 = create(:user)
      @user_4 = create(:user)
      @user_5 = create(:user)

      @merchant = create(:merchant)
      create(:inactive_merchant)

      @order_2 = create(:order, user: @user_2)
      @order_1 = create(:shipped_order, user: @user)
      @order_3 = create(:cancelled_order, user: @user_3)
      @order_4 = create(:shipped_order, user: @user)

      @item_1 = create(:item, user: @merchant)
      @item_2 = create(:item, user: @merchant)
      @item_3 = create(:item, user: @merchant)
      @item_4 = create(:item, user: @merchant)
      @item_5 = create(:item, user: @merchant)
      @item_6 = create(:item, user: @merchant)
      @item_7 = create(:item, user: @merchant)
      @item_8 = create(:item, user: @merchant)
      @item_9 = create(:item, user: @merchant)
      @item_10 = create(:item, user: @merchant)
      @item_11 = create(:item, user: @merchant)

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

      expect(@merchant.top_items_for_merchant).to eq(expected)
    end

    it '.all_orders' do
      expect(@merchant.pending_orders).to eq([@order_2])
    end

    xit '.top_customer_by_order_num' do
      expect(@merchant.top_customer.name).to eq(@user.name)
      expect(@merchant.top_customer.order_num).to eq(2)
    end
  end

  describe "Class methods" do

    it '#active_merchant' do
      merchant = create(:merchant)
      expect(User.active_merchants).to eq([merchant])

      m1,m2 = create_list(:merchant, 2)
      expect(User.active_merchants).to eq([merchant, m1,m2])
    end

     it "reg_users" do
       user_4 = create(:user)
       user_5 = create(:user)
       user_6 = create(:user)

       merchant_1 = create(:merchant)
       merchant_2 = create(:merchant)
       merchant_3 = create(:merchant)

       admin_1 = create(:admin)
       admin_2 = create(:admin)
       admin_3 = create(:admin)

       admin = create(:admin)

       users = User.all
       expect(users.reg_users).to eq([user_4, user_5, user_6])
     end

    it '#date_registered' do
      user = create(:user)

      expect(user.date_registered).to eq(user.created_at.strftime("%B %d, %Y"))
    end

    it '.top_three_states' do
      merchant = create(:merchant)
      user_1 = create(:user, city: "New Orleans", state: "Louisiana")
      user_2 = create(:user, city: "Denver", state: "Colorado")
      user_3 = create(:user, city: "Jacksonville", state: "Florida")
      user_4 = create(:user, city: "Dallas", state: "Texas")

      o1 = create(:order, user: user_1, status: "shipped")
      o2 = create(:order, user: user_2, status: "shipped")
      o3 = create(:order, user: user_3, status: "shipped")
      o4 = create(:order, user: user_4, status: "shipped")

      i1 = create(:item, user: merchant)

      oi1 = create(:order_item, item: i1, quantity: 50, fulfilled: true, order: o2)
      oi1 = create(:order_item, item: i1, quantity: 25, fulfilled: true, order: o3)
      oi1 = create(:order_item, item: i1, quantity: 100, fulfilled: true, order: o1)
      oi1 = create(:order_item, item: i1, quantity: 3, fulfilled: true, order: o4)


      expect(merchant.top_three_states.map(& :state)).to eq(["Louisiana", "Colorado", "Florida"])
    end
    xit ".disable_items" do
      merchant = create(:merchant)
        item_1 = create(:item, user: merchant)
        item_2 = create(:item, user: merchant)
        item_3 = create(:item, user: merchant)

      expect(merchant.disable_items).to eq([item_1, item_2, item_3]) 
      item_1.reload
      item_2.reload
      item_3.reload
      expect(item_1.active).to eq(false)
      expect(item_2.active).to eq(false)
      expect(item_3.active).to eq(false)
    end
  end
end
