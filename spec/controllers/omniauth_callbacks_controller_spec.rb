require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController , :type => :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  describe "get facebook" do
    context "without an existing user" do
      it "creates a new user" do
        expect {
          get :facebook
        }.to change{ User.count }.by(1)
      end

      it "creates a new person" do
        expect {
          get :facebook
        }.to change{ Person.count }.by(1)
      end

      it "signs the user in" do
        get :facebook
        expect(controller.current_user).to eq(User.last)
      end
    end

    context "with an existing user" do
      let!(:user) { FactoryGirl.create(:user, provider: "facebook", email: "test@test.com", uid: "123545") }

      it "does not create a new user" do
        expect {
          get :facebook
        }.to_not change{ User.count }
      end

      it "creates a new person" do
        expect {
          get :facebook
        }.to change{ Person.count }.by(1)
      end

      it "signs the user in" do
        get :facebook
        expect(controller.current_user).to eq(user)
      end
    end

    context "with an existing user and person" do
      let!(:user) { FactoryGirl.create(:user, provider: "facebook", email: "test@test.com", uid: "123545") }
      let!(:person) { FactoryGirl.create(:person, name: "Test", email: "test@test.com") }

      it "does not create a new person" do
        expect {
          get :facebook
        }.to_not change{ Person.count }
      end
    end
  end
end
