FactoryBot.define do

  factory :profile do
    nickname           { Faker::Pokemon.name }
    body      { Faker::Lorem.paragraph }
    last_name { '伊達' }
    first_name { '政宗' }
    last_name_kana { 'だて' }
    first_name_kana { 'まさむね' }
    birth_year { 2000 }
    birth_month { 1 }
    birth_day { 1 }
    phone_number { '08077777777' }
    zipcode { Faker::Number.number(7) }
    prefecture { 4 }
    city { '仙台市青葉区' }
    block { '天主台 ' }
    building { '青葉城址' }
    user_id { 1 }
  end

end
