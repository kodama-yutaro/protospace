require 'rails_helper'

RSpec.feature 'user', type: :feature do
  given(:user) { build(:user) }
  given(:product) { build(:product) }
  it 'creates a new product', js: true do
    visit root_path
    click_on 'Get Started'
    fill_in 'Email address', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    click_on 'New Proto'
    fill_in 'product_title', with: product.title
    fill_in 'product_catch_copy', with: product.catch_copy
    fill_in 'product_concept', with: product.concept
    attach_file 'product[product_images_attributes][0][image]', "#{Rails.root}/spec/fixtures/hoge.jpg"
    1.upto(3) do |i|
      attach_file "product[product_images_attributes][#{i}][image]", "#{Rails.root}/spec/fixtures/hoge.jpg"
    end
    click_on 'Publish'
    expect(page).to have_content 'プロトタイプを投稿しました。'
    page.save_screenshot 'sample.png'
  end
end
