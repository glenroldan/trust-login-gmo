require 'rails_helper'

describe Group, type: :model do
  describe 'validations' do
    subject { build(:group) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:company_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:users) }
  end

  describe '#users_count' do
    it 'returns the number of users' do
      group = create(:group)
      create(:user, group: group)
      create(:user, group: group)
      expect(group.users_count).to eq(2)
    end
  end
end
