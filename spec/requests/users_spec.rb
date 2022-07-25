require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http signup" do
      get signup_path
      expect(response).to have_http_status(:ok)
    end

    it 'Sign up | Ruby on Rails Tutorial Sample Appが含まれること' do
      get signup_path
      expect(response.body).to include full_title('Sign up')
    end
  end

  describe 'POST /users #create' do
    it '無効な値だと登録されないこと' do
      # 波括弧で囲った部分の処理を実行する前後での変化の有無を検証するテスト
      expect{
        # users_pathにpostリクエストを送信する前後で
        post users_path, params: { user: { name: "",
                                          email: "user@invalid",
                                          password: "foo",
                                          password_confirmation: "bar" } }
        }.to_not change(User, :count)
        # Userモデルの数(User.all.count)に差異が生じるかどうか
        # 差異が発生→無効な値で登録がされている→NG
    end
  end

  context '有効な値の場合' do
    let(:user_params) { { user: { name: 'Example User',
                                  email: 'user@example.com',
                                  password: 'password',
                                  password_confirmation: 'password' } } }

    it '登録されること' do
      expect {
        post users_path, params: user_params
      }.to change(User, :count).by 1
      # 1件増加しているか
    end

    it 'users/showにリダイレクトされること' do
      post users_path, params: user_params
      user = User.last
      expect(response).to redirect_to user
      # post users_path後にリダイレクトが行われるかどうか
    end

    it 'flashが表示されること' do
      post users_path, params: user_params
      expect(flash).to be_any
    end
  end
end
