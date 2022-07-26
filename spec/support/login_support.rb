module LoginSupport
  # 現在のユーザーをログアウトする
  def logged_in?
    !session[:user_id].nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end

end

RSpec.configure do |config|
  config.include LoginSupport
end
