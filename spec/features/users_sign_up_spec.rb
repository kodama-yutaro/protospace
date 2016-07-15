require 'rails_helper'

RSpec.feature 'user', type: :feature do

  given(:user) { build(:user) }
  it 'creates new user', js: true do
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
    expect(page).to have_content 'ようこそ！アカウント登録を受け付けました。'
    page.save_screenshot 'sample.png'
  end
end
