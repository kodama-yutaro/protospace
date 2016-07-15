require 'rails_helper'

describe UsersController do

  describe 'with user login' do
    login_user
    describe 'GET #show' do
      it "assigns the requested to @user" do
        user = create(:user)
        get :show, id: user
        expect(assigns(:user)).to eq user
      end

      it "renders the :show template" do
        user = create(:user)
        get :show, id: user
        expect(response).to render_template :show
      end
    end

    describe 'GET #edit' do
      it "assigns the requested user to @user" do
        user = create(:user)
        get :edit, id: user
        expect(assigns(:user)).to eq user
      end

      it "renders the :edit template" do
        user = create(:user)
        get :edit, id: user
        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      it "locates the requersted @user" do
        user = create(:user)
        patch :update, id: user, user: attributes_for(:user)
        expect(assigns(:user)).to eq user
      end

      it "changes @user's attributes" do
        user = create(:user)
        patch :update, id: user, user: attributes_for(:user, nickname: 'hoge')
        user.reload
        expect(user.nickname).to eq("hoge")
      end

      it "redirects to user_path" do
        user = create(:user)
        patch :update, id: user, user: attributes_for(:user)
        expect(response).to redirect_to user_path
      end

      it "sends flash messages" do
        user = create(:user)
        patch :update, id: user, user: attributes_for(:user)
        expect(response).to redirect_to user_path
        expect(flash[:notice]).to eq("ユーザー情報を更新しました。")
      end
    end
  end

  describe 'without user login' do
    describe 'GET #edit' do
      it "redirects sign_in page" do
        user = create(:user)
        get :show, id: user
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe 'PATCH #update' do
      it "redirects sign_in page" do
        user = create(:user)
        patch :update, id: user, user: attributes_for(:user, nickname: 'hoge')
        user.reload
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
