# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    user_name "testUser"
    email "tester@test.com"
    password "password123"
  end

  factory :yaniv, class: User do
    user_name "Yaniv"
    email "yaniv@test.com"
    password "password123"
  end

  factory :wright, class: User do
    user_name "Wright"
    email "wright@test.com"
    password "password123"
  end

  factory :isaac, class: User do
    user_name "Isaac"
    email "isaac@test.com"
    password "password123"
  end
end
