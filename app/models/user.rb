class User < ApplicationRecord
  belongs_to :company, validate: true
  belongs_to :group, optional: true

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :age, presence: true, numericality: { greater_than: 17 }
  validates :email,
    presence: true,
    uniqueness: { scope: :company_id, case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  # validates_associated :company, :message => "cannot have more than 10 users."
  validate :validate_company_user

  private

  def validate_company_user
    return if company.blank? || company_id_was == company_id

    if company.employees.count >= 10
      errors.add(:company, "cannot have more than 10 users.")
    end
  end
end
