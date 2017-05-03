require "rails_helper"

RSpec.describe StaticPagesController, :type => :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #premium" do
    describe "unauthenticated" do
      it "responds with an HTTP 302 status code" do
        get :premium
        expect(response).to have_http_status(302)
      end

      it "redirects to login page" do
        get :premium
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "authenticated" do
      login_user

      it "responds successfully with an HTTP 200 status code" do
        get :premium
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the premium template" do
        get :premium
        expect(response).to render_template(:premium)
      end
    end
  end

  describe "PATCH #buy" do
    describe "unauthenticated" do
      it "redirects to login page" do
        patch :buy
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "authenticated" do
      login_user

      it "redirects to #premium if user already has premium" do
        subject.current_user.premium = DateTime.now + 1.days
        subject.current_user.balance = 20.0
        patch :buy
        expect(response).to redirect_to(show_premium_path)
        expect(flash[:danger]).to eq "You already have premium account."
      end

      it "redirects to #premium if user has no enough balance" do
        subject.current_user.balance = 9.89
        patch :buy
        expect(response).to redirect_to(show_premium_path)
        expect(flash[:danger]).to eq "Not enough balance."
      end

      it "redirects to auction list if transaction completed" do
        subject.current_user.balance = 200.0
        patch :buy
        expect(response).to redirect_to(auctions_index_path)
        expect(flash[:success]).to eq "You have premium account now."
      end

      it "charges 10$ and adds 30 days of premium account if transaction completed" do
        subject.current_user.balance = 45.20
        patch :buy
        expect(subject.current_user.balance).to eq 35.20
        expect(subject.current_user.premium).to be_within(1.minute).of (DateTime.now + 30.days)
      end
    end
  end
end