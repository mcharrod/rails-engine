FactoryBot.define do
  factory :merchant do
    name { Faker::Restaurant.name }
  end
end
