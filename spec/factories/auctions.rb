FactoryGirl.define do
  factory :auction do
    name { Faker::Book.title }
  end
end