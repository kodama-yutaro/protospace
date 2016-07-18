require 'rails_helper'

feature 'user' do
  given(:user) { build(:user) }
  given(:product) { build(:product) }

  def sign_up
    visit root_path
    click_on 'Get Started'
    click_on 'Sign up now'
    fill_in 'user_nickname', with: user.nickname
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password_confirmation
    fill_in 'user_member', with: user.member
    fill_in 'user_profile', with: user.profile
    fill_in 'user_work', with: user.work
    click_button 'save'
  end

  def sign_in
    visit root_path
    click_on 'Get Started'
    fill_in 'Email address', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  scenario 'user sigh_up' do
    sign_up
  end

  scenario 'login user and create a new product', js: true do
    sign_up
    logout(:user)
    sign_in
    click_on 'New Proto'
    fill_in 'product_title', with: product.title
    attach_file 'product[product_images_attributes][0][image]', "#{Rails.root}/spec/fixtures/hoge.jpg"
    1.upto(3) do |i|
      attach_file "product[product_images_attributes][#{i}][image]", "#{Rails.root}/spec/fixtures/hoge.jpg"
    end
    fill_in 'product_catch_copy', with: product.catch_copy
    fill_in 'product_concept', with: product.concept
    click_on 'Publish'
    expect(page).to have_content 'プロトタイプを投稿しました。'
  end
end
