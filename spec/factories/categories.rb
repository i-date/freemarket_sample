FactoryBot.define do

  factory :category do
    name      { Faker::Pokemon.name }
    parent_id { 0 }
  end

end
