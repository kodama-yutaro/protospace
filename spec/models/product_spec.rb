require 'rails_helper'
describe Product do

  describe 'associations' do
    describe 'with comments' do
      it 'deletes the comments when product is deleted' do
        product = create(:product)
        comment = create(:comment, product: product)
        expect{product.destroy}.to change{Comment.count}.by(-1)
      end
    end

    describe 'with likes' do
      it 'deletes the likes when product is deleted' do
        product = create(:product)
        like = create(:like, product: product)
        expect{product.destroy}.to change{Like.count}.by(-1)
      end
    end
  end

  describe 'validations' do
    describe 'with valid attributes' do
     it "has a valid factory" do
      product = build(:product)
      expect(product).to be_valid
     end
    end

    describe 'without valid attributes' do
     it "is missing a title" do
      product = build(:product, title: "")
      product.valid?
      expect(product.errors[:title]).to include("を入力してください。")
     end

     it "is missing a catch_copy" do
      product = build(:product, catch_copy: "")
      product.valid?
      expect(product.errors[:catch_copy]).to include("を入力してください。")
     end

     it "is missing a concept" do
      product = build(:product, concept: "")
      product.valid?
      expect(product.errors[:concept]).to include("を入力してください。")
     end
    end

    describe '#posted_date' do
     it "returns dates in a specified format" do
      product = build(:product)
      expect(product).to be_valid
     end
    end

    describe '#liked_by?(user)' do
      describe 'when liked by a user' do
       it "returns true" do
        user = create(:user)
        like = create(:like, user_id: user.id)
        expect(Like.find_by(user_id: user.id)).to be_truthy
       end
      end

      describe 'when not liked by a user' do
       it "returns nil" do
        user = create(:user)
        like = create(:like, user_id: "")
        expect(Like.find_by(user_id: user.id)).to be_falsey
       end
      end
    end

  end
end
