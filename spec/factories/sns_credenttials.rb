FactoryBot.define do

  factory :sns_credential do
    uid      { "12345678" }
    provider { "google_oauth2" }
    user_id  { 1 }
  end

end
