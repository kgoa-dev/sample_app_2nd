require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe "#home" do
    # 正常にレスポンスを返すこと
    it "responds successfully" do
      get root_path
      expect(response.body).to include "<title>#{base_title}</title>"
    end
  end

  describe "#help" do
    # 正常にレスポンスを返すこと
    it "responds successfully" do
      get help_path
      expect(response.body).to include "Help | #{base_title}"
    end
  end

  describe "#about" do
    # 正常にレスポンスを返すこと
    it "responds successfully" do
      get about_path
      expect(response.body).to include "About | #{base_title}"
    end
  end

  describe '#contact' do
    it '正常にレスポンスを返すこと' do
      get contact_path
      expect(response).to have_http_status :ok
      expect(response.body).to include "Contact | #{base_title}"
    end
  end

end
