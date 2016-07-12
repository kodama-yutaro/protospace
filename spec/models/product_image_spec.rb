require 'rails_helper'

describe ProductImage do
  describe '#create' do

    describe "with valid attributes" do
    it "has a valid factory" do
      product_image = build(:product_image, :main)
      expect(product_image).to be_valid
    end
  end

    describe "without image attribute" do
      it "returns error" do
        product_image = build(:product_image, image: nil)
        product_image.valid?
        expect(product_image.errors[:image]).to include("を入力してください。")
      end
    end

    describe "without status attribute" do
      it "returns error" do
        product_image = build(:product_image, status: nil)
        product_image.valid?
        expect(product_image.errors[:status]).to include("を入力してください。")
      end
    end

  end
end
