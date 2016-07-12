FactoryGirl.define do

  factory :user do
    nickname              { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              "00000000"
  end

end
