# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersEdits', type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario '間違った情報で編集に失敗する' do
    login_as(user)
    click_on 'Account'
    click_on 'Setting'
    fill_in 'Name', with: 'aaa'
    fill_in 'Email', with: 'user@invalid'
    fill_in 'Password', with: 'foo'
    fill_in 'Password confirmation', with: 'bar'
    click_on 'Save changes'
    aggregate_failures do
      expect(current_path).to eq user_path(user)
      expect(has_css?('.alert-danger')).to be_truthy
    end
  end

  scenario '正しい情報で編集に成功する' do
    login_as(user)
    click_on 'Account'
    click_on 'Setting'
    fill_in 'Name', with: 'FooBar'
    fill_in 'Email', with: 'foo@bar.com'
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_on 'Save changes'
    aggregate_failures do
      expect(current_path).to eq user_path(user)
      expect(has_css?('.alert-success')).to be_truthy
    end
  end
end
