FactoryBot.define do

  factory :item do
    name                 { Faker::Pokemon.name }
    price                { Faker::Number.number(4) }
    description          { Faker::Lorem.characters(10) }
    condition            { '新品・未使用' }
    shipping_fee         { '送料込み・出品者負担' }
    shipping_from        { '北海道' }
    days_before_shipping { '1〜2日で発送' }
    shipping_method      { '未定' }
    status               { 1 }
    brand                { 'ルイ ヴィトン' }
    category_id          { 1 }
    user_id              { 1 }
    size_id              { 1 }
  end

end
