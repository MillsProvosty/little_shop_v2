require 'rails_helper'

RSpec.describe 'as any user', Item do

  before :each do
    create_list(:item, 5)
    create_list(:inactive_item, 5)
  end
  it 'can view all item in the system' do
    visit items_path
    Item.all.each do |item|
      next unless item.active
      within "#item-#{item.id}" do
      expect(page).to have_link(item.name)
      expect(find('img')[:src]).to eq(item.image)
      expect(page).to have_content(item.user.name)
      expect(page).to have_content("In Stock: #{item.inventory}")
      expect(page).to have_content("Price: #{item.price.to_f}")
      end
      end
  end

  it 'cannot view inactive item in the system' do
    visit items_path

    Item.all.each do |item|
      next if item.active
        expect(page).to_not have_link(item.name)
        expect(page).to_not have_content(item.user.name)
        expect(page).to_not have_content("In Stock: #{item.inventory}")
        expect(page).to_not have_content("Price: #{item.price.to_f}")
    end
  end
  describe "Items index stats" do
    before :each do
      @item_1 = create(:item)
      @item_2 = create(:item)
      @item_3 = create(:item)
      @item_4 = create(:item)
      @item_5 = create(:item)
      @item_6 = create(:item)
      @item_7 = create(:item)
      @item_8 = create(:item)
      @item_9 = create(:item)
      @item_10 = create(:item)

      @oi_1 = create(:order_item, item: @item_1, quantity: 8, fulfilled: true)
      @oi_2 = create(:order_item, item: @item_2, quantity: 1, fulfilled: true)
      @oi_3 = create(:order_item, item: @item_3, quantity: 4, fulfilled: true)
      @oi_4 = create(:order_item, item: @item_4, quantity: 6, fulfilled: true)
      @oi_5 = create(:order_item, item: @item_5, quantity: 3, fulfilled: true)
      @oi_6 = create(:order_item, item: @item_6, quantity: 5, fulfilled: true)
      @oi_7 = create(:order_item, item: @item_7, quantity: 2, fulfilled: true)
      @oi_8 = create(:order_item, item: @item_8, quantity: 7, fulfilled: true)
      @oi_9 = create(:order_item, item: @item_9, quantity: 10, fulfilled: true)
      @oi_10 = create(:order_item, item: @item_10, quantity: 9, fulfilled: true)

      @oi_n1 = create(:order_item, item: @item_1, quantity: 11, fulfilled: false)
      @oi_n2 = create(:order_item, item: @item_2, quantity: 1, fulfilled: false)
      @oi_n3 = create(:order_item, item: @item_3, quantity: 2, fulfilled: false)
      @oi_n4 = create(:order_item, item: @item_4, quantity: 1, fulfilled: false)
      @oi_n5 = create(:order_item, item: @item_5, quantity: 4, fulfilled: false)
      @oi_n6 = create(:order_item, item: @item_6, quantity: 6, fulfilled: false)
      @oi_n7 = create(:order_item, item: @item_7, quantity: 11, fulfilled: false)
      @oi_n8 = create(:order_item, item: @item_8, quantity: 12, fulfilled: false)
      @oi_n9 = create(:order_item, item: @item_9, quantity: 3, fulfilled: false)
      @oi_n10 = create(:order_item, item: @item_10, quantity: 8, fulfilled: false)

    end
    describe "As any kind of user, I see stats on items index" do
        it "I see top 5 most popular items" do

          visit items_path

          within(".item-stats") do
            expect(page).to have_content("Most popular items")
            expect(page.all("p")[0]).to have_content("#{@item_9.name}, bought #{@oi_9.quantity} times")
            expect(page.all("p")[1]).to have_content("#{@item_10.name}, bought #{@oi_10.quantity} times")
            expect(page.all("p")[2]).to have_content("#{@item_1.name}, bought #{@oi_1.quantity} times")
            expect(page.all("p")[3]).to have_content("#{@item_8.name}, bought #{@oi_8.quantity} times")
            expect(page.all("p")[4]).to have_content("#{@item_4.name}, bought #{@oi_4.quantity} times")
          end
        end
        it "I see top 5 least popular items" do

          visit items_path
          within(".item-stats") do
            expect(page).to have_content("Least popular items")
            expect(page.all("p")[5]).to have_content("#{@item_2.name}, bought #{@oi_2.quantity} times")
            expect(page.all("p")[6]).to have_content("#{@item_7.name}, bought #{@oi_7.quantity} times")
            expect(page.all("p")[7]).to have_content("#{@item_5.name}, bought #{@oi_5.quantity} times")
            expect(page.all("p")[8]).to have_content("#{@item_3.name}, bought #{@oi_3.quantity} times")
            expect(page.all("p")[9]).to have_content("#{@item_6.name}, bought #{@oi_6.quantity} times")
          end
        end
      end
    end
  end

# As any kind of user on the system
# When I visit the items index page ("/items")
# I see an area with statistics:
# - the top 5 most popular items by quantity purchased, plus the quantity bought
# - the bottom 5 least popular items, plus the quantity bought
#
# "Popularity" is determined by total quantity of that item fulfilled
