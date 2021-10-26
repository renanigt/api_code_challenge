FactoryBot.define do
  factory :hostname do
    hostname { Faker::Internet.domain_name }
  end
end
