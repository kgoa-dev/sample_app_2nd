# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /new' do
    it 'returns http signup' do
      get signup_path
      expect(response).to have_http_status(:ok)
    end

    it 'Sign up | Ruby on Rails Tutorial Sample Appが含まれること' do
      get signup_path
      expect(response.body).to include full_title('Sign up')
    end
  end

  describe 'GET /users' do
    it 'ログインユーザでなければログインページにリダイレクトすること' do
      get users_path
      expect(response).to redirect_to login_path
    end

    describe 'pagination' do
      before do
        30.times do
          FactoryBot.create(:continuous_users)
        end
        log_in user
        get users_path
      end

      it 'div.paginationが存在すること' do
        expect(response.body).to include '<div role="navigation" aria-label="Pagination" class="pagination">'
      end

      it 'ユーザごとのリンクが存在すること' do
        User.paginate(page: 1).each do |user|
          expect(response.body).to include "<a href=\"#{user_path(user)}\">"
        end
      end
    end
  end

  describe 'POST /users #create' do
    it '無効な値だと登録されないこと' do
      # 波括弧で囲った部分の処理を実行する前後での変化の有無を検証するテスト
      expect do
        # users_pathにpostリクエストを送信する前後で
        post users_path, params: { user: { name: '',
                                           email: 'user@invalid',
                                           password: 'foo',
                                           password_confirmation: 'bar' } }
      end.to_not change(User, :count)
      # Userモデルの数(User.all.count)に差異が生じるかどうか
      # 差異が発生→無効な値で登録がされている→NG
    end

    context '有効な値の場合' do
      let(:user_params) do
        { user: { name: 'Example User',
                  email: 'user@example.com',
                  password: 'password',
                  password_confirmation: 'password' } }
      end

      before do
        ActionMailer::Base.deliveries.clear
        log_in user
      end

      it '登録されること' do
        expect do
          post users_path, params: user_params
        end.to change(User, :count).by 1
        # 1件増加しているか
      end

      it 'users/showにリダイレクトされること' do
        post users_path, params: user_params
        user = User.last
        expect(response).to redirect_to root_url
        # post users_path後にリダイレクトが行われるかどうか
      end

      it 'flashが表示されること' do
        post users_path, params: user_params
        expect(flash).to be_any
      end

      it 'ログイン状態であること' do
        post users_path, params: user_params
        expect(logged_in?).to be_truthy
      end

      it 'メールが1件存在すること' do
        post users_path, params: user_params
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it '登録時点ではactivateされていないこと' do
        post users_path, params: user_params
        expect(User.last).to_not be_activated
      end
    end
  end

  describe 'get /users/{id}/edit' do
    it 'タイトルがEdit user | Ruby on Rails Tutorial Sample Appであること' do
      log_in user
      get edit_user_path(user)
      expect(response.body).to include full_title('Edit user')
    end

    context '未ログインの場合' do
      it 'flashが空でないこと' do
        get edit_user_path(user)
        expect(flash).to_not be_empty
      end

      it '未ログインユーザはログインページにリダイレクトされること' do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it 'ログインすると編集ページにリダイレクトされること' do
        get edit_user_path(user)
        log_in user
        expect(response).to redirect_to edit_user_path(user)
      end
    end
  end

  describe 'PATCH /users' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:other_user) }

    it 'タイトルがEdit user | Ruby on Rails Tutorial Sample Appであること' do
      log_in(user)
      get edit_user_path(user)
      expect(response.body).to include full_title('Edit user')
    end

    context '無効な値の場合' do
      it '更新できないこと' do
        log_in(user)
        patch user_path(user), params: { user: {
          name: ' ',
          email: 'foo@invalid',
          password: 'foo',
          password_confirmation: 'bar'
        } }
        expect(response).to have_http_status(:ok)

        user.reload
        expect(user.name).to_not eq ''
        expect(user.email).to_not eq ''
        expect(user.password).to_not eq 'foo'
        expect(user.password_confirmation).to_not eq 'bar'
      end

      it '更新アクション後にeditのページが表示されていること' do
        log_in(user)
        get edit_user_path(user)
        patch user_path(user), params: { user: { name: ' ',
                                                 email: 'foo@invalid',
                                                 password: 'foo',
                                                 password_confirmation: 'bar' } }
        expect(response.body).to include full_title('Edit user')
      end
    end

    context '有効な値の場合' do
      before do
        log_in(user)
        @name = 'Foo Bar'
        @email = 'foo@bar.com'
        patch user_path(user), params: { user: { name: @name,
                                                 email: @email,
                                                 password: 'password',
                                                 password_confirmation: 'password' } }
      end

      it '更新できること' do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end

      it 'Users#showにリダイレクトすること' do
        expect(response).to redirect_to user
      end

      it 'flashが表示されていること' do
        expect(flash).to be_any
      end
    end

    context '未ログインの場合' do
      it 'flashが空でないこと' do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(flash).to_not be_empty
      end

      it '未ログインユーザはログインページにリダイレクトされること' do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(response).to redirect_to login_path
      end
    end

    context '別のユーザの場合' do
      it 'flashが空であること' do
        log_in user
        get edit_user_path(other_user)
        expect(flash).to be_empty
      end

      it 'root_pathにリダイレクトされること' do
        log_in user
        get edit_user_path(other_user)
        expect(response).to redirect_to root_path
      end
    end

    it 'admin属性は更新できないこと' do
      # userはこの後adminユーザになるので違うユーザにしておく
      log_in user = FactoryBot.create(:lana)
      expect(user).to_not be_admin

      patch user_path(user), params: { user: { password: 'password',
                                               password_confirmation: 'password',
                                               admin: true } }
      user.reload
      expect(user).to_not be_admin
    end
  end

  describe 'DELETE /users/{id}' do
    let!(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:other_user) }

    context '未ログインの場合' do
      it '削除できないこと' do
        expect do
          delete user_path(user)
        end.to_not change(User, :count)
      end

      it 'ログインページにリダイレクトすること' do
        delete user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    context 'adminユーザでない場合' do
      it '削除できないこと' do
        log_in other_user
        expect do
          delete user_path(user)
        end.to_not change(User, :count)
      end

      it 'rootにリダイレクトすること' do
        log_in other_user
        delete user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET /users/{id}/followings' do
    let(:user) { FactoryBot.create(:user) }

    it '未ログインならログインページにリダイレクトすること' do
      get followings_user_path(user)
      expect(response).to redirect_to login_path
    end
  end

  describe 'GET /users/{id}/followers' do
    let(:user) { FactoryBot.create(:user) }

    it '未ログインならログインページにリダイレクトすること' do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end
  end
end
