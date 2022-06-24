class Company < ApplicationRecord
  has_many :employees, dependent: :destroy, class_name: 'User'
  has_many :groups, dependent: :destroy

  validates :code, presence: true, uniqueness: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z0-9\-]+\z/ }
  validates :employees, length: { maximum: 10 }
end
