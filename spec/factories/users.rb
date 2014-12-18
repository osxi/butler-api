FactoryGirl.define do
  factory :user do
    first_name 'Firstname'
    last_name 'Lastname'
    email 'nobody@poeticsystems.com'
    fb_staff_id 1
    trello_username '@first_name_poetic'
    manager false
    slack_id '#snitch'
    association :team
  end
end
