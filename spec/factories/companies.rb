FactoryBot.define do
  factory :company do
    code { Faker::Alphanumeric.alphanumeric(number: 50) }
  end
end
