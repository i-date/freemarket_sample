FactoryBot.define do

  factory :sns_user do
    password = "tester1234"

    nickname              { "tester" }
    email                 { Faker::Internet.email }
    password              { password }
    password_confirmation { password }
    uid                   { "12345678" }
    provider              { "google_oauth2" }
  end

end
