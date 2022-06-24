require 'rails_helper'

describe Company, type: :model do
  describe 'validations' do
    subject { build(:company) }

    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
    it { is_expected.to validate_length_of(:code).is_at_most(50) }

    context 'with users' do
      before { subject.employees << build_list(:user, 10) }

      it 'allows to have 10 users' do
        is_expected.to be_valid
      end

      it 'does not allow to have more than 10 users' do
        subject.employees << build(:user)
        is_expected.not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:groups) }
    it { is_expected.to have_many(:employees).class_name('User') }
  end
end
