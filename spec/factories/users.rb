FactoryGirl.define do

  factory :user do
    nickname              { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              "00000000"
    password_confirmation "00000000"
    avatar                { Faker::Avatar.image }
    member                { Faker::Team.creature }
    profile               { Faker::University.name}
    work                  { Faker::Company.name }
  end

end
