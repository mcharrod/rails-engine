FactoryBot.define do
  factory :item do
    merchant
    name { Faker::Creature::Animal.name }
    description { Faker::Lorem.sentence(word_count: 25) }
    unit_price { Faker::Number.number(digits: 4) }
  end
end
