FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@test.com"
  end
  factory :user do
    email
    password "123456"
  end

  trait :with_api_token do
    after :create do |user|
      FactoryGirl.create :api_token, user: user
    end
  end

  trait :with_api_token_1 do
    after :create do |user|
      FactoryGirl.create :api_token, user: user, api_token: "547b942bcb733ff30877ccf104ba2beedsefd"
    end
  end
end
