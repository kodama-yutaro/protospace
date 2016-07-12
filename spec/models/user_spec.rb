require 'rails_helper'
describe User do
  describe '#create' do

    describe 'with valid attributes' do
     it "is valid with all information" do
      user = build(:user)
      expect(user).to be_valid
     end
    end

    describe 'without valid attributes' do
     it "is invalid without a nickname" do
      user = build(:user, nickname: "")
      user.valid?
      expect(user.errors[:nickname]).to include("を入力してください。")
     end

     it "is invalid without an email" do
      user = build(:user, email: "")
      user.valid?
      expect(user.errors[:email]).to include("を入力してください。")
     end

     it "is invalid without a password" do
      user = build(:user, password: "")
      user.valid?
      expect(user.errors[:password]).to include("を入力してください。")
     end

     it "is invalid without a password_confirmation" do
      user = build(:user, password: "")
      user.valid?
      expect(user.errors[:password]).to include("を入力してください。")
     end

     it "is invalid without a password_confirmation although with a password" do
      user = build(:user, password: "0000000")
      user.valid?
      expect(user.errors[:password]).to include("は8文字以上で入力してください。")
     end

     it "is invalid with a password that has less than 7 characters " do
      user = build(:user, password: "0000000")
      user.valid?
      expect(user.errors[:password][0]).to include("は8文字以上で入力してください。")
    end
    end

 end
end
