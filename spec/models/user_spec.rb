require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { FactoryGirl.create(:user) }

  it '#name' do
    full_name = "#{user.first_name} #{user.last_name}"
    expect(user.name).to eq(full_name)
  end
end
