class Item < ApplicationRecord
  validates_presence_of :name, :active, :description, :image
  validates_numericality_of :price, :inventory

  belongs_to :user
  
end
