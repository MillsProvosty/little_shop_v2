class User < ApplicationRecord
  has_secure_password

  validates_presence_of :password, :active, :name, :address, :city,
                        :state, :zip
  validates_uniqueness_of :email
  validates_numericality_of :role

  has_many :items
  has_many :orders
end
