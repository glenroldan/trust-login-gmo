class Group < ApplicationRecord
  belongs_to :company
  has_many :users

  validates :name,
    presence: true,
    uniqueness: { scope: :company_id, case_sensitive: false },
    length: { maximum: 100 }

  def users_count
    users.count
  end
end
