FactoryGirl.define do
  factory :user do
    first_name 'Firstname'
    last_name 'Lastname'
    sequence(:email) { |n| "nobody-#{n}@poeticsystems.com" }
    fb_staff_id 1
    trello_username '@first_name_poetic'
    manager false
    slack_id '#snitch'
    password 'weakpass123'
    password_confirmation 'weakpass123'
    association :team
  end
end
