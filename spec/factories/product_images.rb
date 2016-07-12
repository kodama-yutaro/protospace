FactoryGirl.define do

  factory :product_image do
    image        { fixture_file_upload("spec/fixtures/hoge.jpg") }

    trait :main do
      status   :main
    end

    trait :sub do
      status   :sub
    end

  end
end
