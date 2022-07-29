# frozen_string_literal: true

module LoginSupport
  module Request
    # テストユーザーとしてログインする
    def log_in(user)
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
    end

    # 現在のユーザーをログアウトする
    def logged_in?
      controller.logged_in?
    end

    # 現在のユーザーをログアウトする
    def log_out
      session.delete(:user_id)
      @current_user = nil
    end
  end

  module System
    def login_as(user)
      visit login_path
      fill_in 'Email',    with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end
  end
end

RSpec.configure do |config|
  config.include LoginSupport::System, type: :system
  config.include LoginSupport::Request, type: :request
end
