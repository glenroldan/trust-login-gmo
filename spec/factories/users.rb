FactoryBot.define do
  factory :user do
    association :company, factory: :company
    # association :group, factory: :group
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    age { Faker::Number.between(from: 18, to: 65) }
  end
end
