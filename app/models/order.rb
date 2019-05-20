class Order < ApplicationRecord

  validates_numericality_of :status
  
  belongs_to :user
end
