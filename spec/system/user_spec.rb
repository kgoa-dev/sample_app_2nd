# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserSpecs', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '#create' do
    context '無効な値の場合' do
      it '' do
        visit signup_path
        # fill_inは指定のフォームにwith:で指定した文字列を入力するメソッド
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'user@invlid'
        fill_in 'Password', with: 'foo'
        fill_in 'Password confirmation', with: 'bar'
        click_button 'Create my account'

        # have_selector = 特定の要素がページ上に存在するか
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
        # エラーメッセージを表示しているdivタグの有無を検証
      end
    end
  end
end
