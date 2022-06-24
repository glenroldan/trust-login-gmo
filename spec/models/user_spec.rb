require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_most(50) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(50) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_numericality_of(:age).is_greater_than(17) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive.scoped_to(:company_id) }
    it { is_expected.to allow_value('user@test.com').for(:email ) }
    it { is_expected.not_to allow_value('user').for(:email ) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:group).optional }
  end
end
