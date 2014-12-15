require 'rails_helper'

RSpec.describe User, type: :model do
  context 'instance' do
    let(:user) { FactoryGirl.create(:user) }

    it '#name' do
      full_name = "#{user.first_name} #{user.last_name}"
      expect(user.name).to eq(full_name)
    end
  end

  context '#try_name_from_fb_staff_id' do
    let(:user) { FactoryGirl.create(:user, fb_staff_id: 1) }

    it 'finds user by id' do
      expect(user.name).to eq User.try_name_from_fb_staff_id(1)
    end

    it 'returns "Unknown Staff" when none found' do
      expect('Unknown Staff').to eq User.try_name_from_fb_staff_id(8123)
    end
  end

  describe 'creates authentication token before_save' do
    let(:user) { FactoryGirl.create(:user) }

    it 'creates one if blank' do
      user.authentication_token = ''
      user.save

      expect(user.authentication_token).to_not eq ''
    end

    it 'doesn\'t update if already exists' do
      user.authentication_token = 'existingToken'
      user.save

      expect(user.authentication_token).to eq 'existingToken'
    end

  end
end
