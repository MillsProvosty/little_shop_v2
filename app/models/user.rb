class User < ApplicationRecord
  has_secure_password
  validates_presence_of :role, :password, :name, :address, :city,
                        :state, :zip

  validates_inclusion_of :active, in: [true, false]

  validates_uniqueness_of :email

#  validates_numericality_of :role
  enum role: %w[user merchant admin]
  has_many :items
  has_many :orders



end
