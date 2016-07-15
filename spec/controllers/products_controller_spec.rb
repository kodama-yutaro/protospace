require 'rails_helper'

describe ProductsController do

  describe 'with user login' do
    login_user
    describe 'GET #index' do
      it "assigns the requested products to @products" do
        products = create_list(:product, 1)
        get :index
        expect(assigns(:products)).to match(products)
      end

      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET #new' do
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      describe 'with valid attributes' do
        it "saves the new contact in the database" do
          product = build(:product)
          post :create, product: attributes_for(:product)
          expect{product.save}.to change(Product, :count).by(1)
        end

        it "redirects to root_path" do
          product = build(:product)
          post :create, product: attributes_for(:product)
          expect(response).to redirect_to products_path
        end

        it "shows flash messages to show save the product successfully" do
          product = create(:product)
          post :create, product: attributes_for(:product)
          expect(flash[:notice]).to eq("プロトタイプを投稿しました。")
        end
      end
    end

    describe 'GET #show' do
      it "assigns the requested to @product" do
        product = create(:product)
        get :show, id: product
        expect(assigns(:product)).to eq product
      end

      it "renders the :show template" do
        product = create(:product)
        get :show, id: product
        expect(response).to render_template :show
      end
    end

    describe 'GET #edit' do
      it "assigns the requested contact to @product" do
        product = create(:product)
        get :edit, id: product
        expect(assigns(:product)).to eq product
      end

      it "renders the :edit template" do
        product = create(:product)
        get :edit, id: product
        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      it "assigns the requersted product to @product" do
        product = create(:product)
        patch :update, id: product, product: attributes_for(:product)
        expect(assigns(:product)).to eq product
      end

      it "update attributes of product" do
        product = create(:product, title: "hoge")
        patch :update, id: product, product: attributes_for(:product, title: "hoge")
        product.reload
        expect(product.title).to eq("hoge")
      end

      it "redirects to products_path" do
        product = create(:product)
        patch :update, id: product, article: attributes_for(:product)
        expect(response).to redirect_to products_path
      end

      it "shows flash message to show update product flash messages" do
        product = create(:product)
        patch :update, id: product, product: attributes_for(:product)
        expect(flash[:notice]).to eq("プロトタイプを更新しました。")
      end
    end

    describe 'DELETE #destroy' do
      it "assigns the requested product to @product" do
        product = create(:product)
        delete :destroy, id: product
        expect(assigns(:product)).to eq product
      end

      it "deletes the product" do
        product = create(:product)
        delete :destroy, id: product
        expect{product.destroy}.to change(Product, :count).by(-1)
      end

      it "redirects to products_path" do
        product = create(:product)
        delete :destroy, id: product, article: attributes_for(:product)
        expect(response).to redirect_to products_path
      end

      it "shows flash message to show delete product successfully" do
        product = create(:product)
        delete :destroy, id: product, article: attributes_for(:product)
        expect(flash[:notice]).to eq("プロトタイプを削除しました。")
      end
    end
  end

  describe 'without user login' do
    describe 'GET #new' do
      it "redirects sign_in page" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it "redirects sign_in page" do
        post :create, product: attributes_for(:product)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #edit' do
      it "redirects sign_in page" do
        product = create(:product)
        get :edit, id: product
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PATCH #update' do
      it "redirects sign_in page" do
        product = create(:product)
        patch :update, id: product, article: attributes_for(:product)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE #destroy' do
      it "redirects sign_in page" do
        product = create(:product)
        delete :destroy, id: product, article: attributes_for(:product)
        expect(response).to redirect_to new_user_session_path
      end
    end

  end
end
