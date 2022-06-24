FactoryBot.define do
  factory :group do
    association :company, factory: :company
    name { Faker::Games::SuperSmashBros.fighter }
  end
end
