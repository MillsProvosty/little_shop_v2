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

  describe "class methods" do
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

    @o1 = create(:order, status: "shipped", user: @buyer1)
    @o2 = create(:order, status: "cancelled", user: @buyer2)
    @o3 = create(:order, status: "shipped", user: @buyer3)
    @o4 = create(:order, status: "shipped", user: @buyer4)
    @o5 = create(:order, status: "cancelled", user: @buyer1)
    @o6 = create(:order, status: "shipped", user: @buyer1)
    @o7 = create(:order, status: "shipped", user: @buyer1)
    @o8 = create(:order, status: "shipped", user: @buyer3)
    @o9 = create(:order, status: "pending", user: @buyer2)

    @i1 = create(:item, price: 100, user: @merch1)
    @i2 = create(:item, price: 50, user: @merch2)
    @i3 = create(:item, price: 20, user: @merch3)

    @oi1 = create(:order_item, price: 100, created_at: 40.days.ago, updated_at: 3.hours.ago, quantity: 2, order: @o1, fulfilled: true, item: @i1)
    @oi2 = create(:order_item, price: 100, created_at: 35.days.ago, updated_at: 3.hours.ago, quantity: 1, order: @o2, fulfilled: true, item: @i1)
    @oi3 = create(:order_item, price: 300, created_at: 30.days.ago, updated_at: 3.hours.ago, quantity: 3, order: @o3, fulfilled: true, item: @i1)
    @oi4 = create(:order_item, price: 400, created_at: 20.days.ago, updated_at: 3.hours.ago, quantity: 10, order: @o4, fulfilled: true, item: @i2)
    @oi5 = create(:order_item, price: 500, created_at: 25.days.ago, updated_at: 3.hours.ago, quantity: 2, order: @o5, fulfilled: true, item: @i2)
    @oi6 = create(:order_item, price: 600, created_at: 15.days.ago, updated_at: 3.hours.ago, quantity: 3, order: @o6, fulfilled: true, item: @i2)
    @oi7 = create(:order_item, price: 700, created_at: 15.days.ago, updated_at: 3.hours.ago, quantity: 10, order: @o7, fulfilled: true, item: @i3)
    @oi8 = create(:order_item, price: 800, created_at: 10.days.ago, updated_at: 3.hours.ago, quantity: 1, order: @o8, fulfilled: true, item: @i3)
    @oi9 = create(:order_item, price: 900, created_at: 5.days.ago, updated_at: 3.hours.ago, quantity: 5, order: @o9, fulfilled: true, item: @i3)
    @oi10 = create(:order_item, price: 100, created_at: 1.days.ago, updated_at: 3.hours.ago, quantity: 1, order: @o2, fulfilled: false, item: @i1)
    @oi11 = create(:order_item, price: 1900, created_at: 2.days.ago, updated_at: 3.hours.ago, quantity: 5, order: @o3, fulfilled: false, item: @i1)
    @oi12 = create(:order_item, price: 400, created_at: 3.days.ago, updated_at: 3.hours.ago, quantity: 4, order: @o4, fulfilled: false, item: @i2)
    @oi13 = create(:order_item, price: 700, created_at: 4.days.ago, updated_at: 3.hours.ago, quantity: 7, order: @o5, fulfilled: false, item: @i2)
    @oi14 = create(:order_item, price: 800, created_at: 5.days.ago, updated_at: 3.hours.ago, quantity: 2, order: @o6, fulfilled: false, item: @i3)
    @oi = create(:order_item, price: 100000, created_at: 6.days.ago, updated_at: 3.hours.ago, quantity: 1 , order: @o7, fulfilled: false, item: @i3)
  end

    it '.topthreesellers' do
      expect(User.topthreesellers.map(& :name)).to eq([@merch3.name, @merch2.name, @merch1.name])
    end

    it '.topthreetimes' do
      expect(User.topthreetimes.map(& :name)).to eq([@merch3.name, @merch2.name, @merch1.name])
    end

    it '.worstthreetimes' do
      expect(User.worstthreetimes.map(& :name)).to eq([@merch1.name, @merch2.name, @merch3.name])
    end

    it '.topthreestates' do
      expect(User.topthreestates.map(& :state)).to eq([@buyer1.state, @buyer3.state, @buyer4.state])
    end

    it '.topthreecities' do
      expect(User.topthreecities.map(& :city)).to eq([@buyer1.city, @buyer3.city, @buyer4.city])
      expect(User.topthreecities.map(& :state)).to eq([@buyer1.state, @buyer3.state, @buyer4.state])
    end

    it '.topthreeorders' do
      expect(User.topthreeorders.map(& :id)).to match_array([@o3.id, @o4.id, @o7.id])
    end
  end
end
