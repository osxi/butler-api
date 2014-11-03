require 'rails_helper'

describe 'Factory Girl' do
  FactoryGirl.factories.map(&:name).each do |factory_name|
    describe "#{factory_name} factory" do
      # Test each factory
      it 'is valid' do
        factory = FactoryGirl.build(factory_name)
        if factory.respond_to?(:valid?)
          expect(factory).to be_valid, lambda {
            factory.errors.full_messages.join(' ')
          }
        end
      end

      # Test each trait
      trait_names = FactoryGirl.factories[factory_name].definition
                    .defined_traits.map(&:name)

      trait_names.each do |trait_name|
        context "with trait #{trait_name}" do
          it 'is valid' do
            factory = FactoryGirl.build(factory_name, trait_name)
            if factory.respond_to?(:valid?)
              expect(factory).to be_valid, lambda {
                factory.errors.full_messages.join(' ')
              }
            end
          end
        end
      end
    end
  end
end
