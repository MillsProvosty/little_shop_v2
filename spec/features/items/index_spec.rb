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
end
