FactoryGirl.define do
  factory :time_entry do
    fb_project_id 1
    fb_task_id 1
    fb_staff_id 1
    notes 'Did something cool'
    hours 1.5
    date '2014-10-31'
    trello_card_id 'abc1234'
    association :user
  end
end
