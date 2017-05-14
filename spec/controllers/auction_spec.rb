require "rails_helper"

RSpec.describe AuctionsController, :type => :controller do
  describe "unauthenticated" do
    it "redirects to login page" do
      get :new
      expect(response).to redirect_to(new_user_session_path)
      post :create
      expect(response).to redirect_to(new_user_session_path)
      get :bid, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
      get :edit, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
      delete :delete, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
      get :wins
      expect(response).to redirect_to(new_user_session_path)
      get :shipping
      expect(response).to redirect_to(new_user_session_path)
      get :ship, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
      patch :save, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
      get :history
      expect(response).to redirect_to(new_user_session_path)
      patch :pay, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "authenticated" do
    login_user

    describe "GET #index" do
      it "loads all of the auctions in ascending order into @auctions" do
        auction1, auction2, auction3 = 
          Auction.create!(name: 'MacBook', finish_at: DateTime.now + 2.days), 
          Auction.create!(name: 'iPhone', finish_at: DateTime.now + 3.days),
          Auction.create!(name: 'iPad', finish_at: DateTime.now + 1.days)

        get :index

        expect(assigns(:auctions)[0]).to eq auction3
        expect(assigns(:auctions)[1]).to eq auction1
        expect(assigns(:auctions)[2]).to eq auction2
      end

      it "renders index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe "GET #new" do
      it "redirects to root page with no rights" do
        get :new
        expect(response).to redirect_to(root_path)
      end
      
      it "prepares auction object into @auction" do
        subject.current_user.role = 1
        get :new
        expect(assigns(:auction)).to be_a_kind_of Auction
      end

      it "renders new template" do
        subject.current_user.role = 1
        get :new
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      it "redirects to root page with no rights" do
        post :create, params: { auction: { name: 'MacBook', premium: false, photo: nil, finish_at: DateTime.now } }
        expect(response).to redirect_to(root_path)
      end

      it "inserts new auction with valid params" do
        subject.current_user.role = 1

        auction_count = Auction.all.count
        post :create, params: { auction: { name: 'MacBook Pro 20', premium: false, photo: nil, finish_at: DateTime.now } }
        expect(Auction.all.count).to eq (auction_count + 1)
      end

      it "redirects to auction list with success message if valid params" do
        subject.current_user.role = 1

        post :create, params: { auction: { name: 'MacBook Pro 20', premium: false, photo: nil, finish_at: DateTime.now } }
        expect(response).to redirect_to(auctions_index_path)
        expect(flash[:success]).to eq "Auction has been inserted."
      end

      it "renders new template with invalid params" do
        subject.current_user.role = 1

        post :create, params: { auction: { name: nil, premium: false, photo: nil, finish_at: DateTime.now } }

        expect(response).to render_template(:new)
      end
    end

    describe "GET #show" do
      it "should raise error if cannot find id" do
        expect { get :show, params: { id: 10000 } }.to raise_error ActiveRecord::RecordNotFound
      end

      it "should prepare auction into @auction" do
        auction = Auction.create!(name: 'MacBook')

        get :show, params: { id: auction.id }

        expect(assigns(:auction)).to eq auction
      end
    end

    describe "GET #edit" do
      it "should redirect to root page if unauthorized" do
        auction = Auction.create!(name: 'MacBook')
        get :edit, params: { id: auction.id }
        expect(response).to redirect_to(root_path)
      end

      it "should raise error if cannot find id" do
        subject.current_user.role = 1
        expect { get :edit, params: { id: 10000 } }.to raise_error ActiveRecord::RecordNotFound
      end

      it "should prepare auction for edit into @auction" do
        auction = Auction.create!(name: 'MacBook')

        get :edit, params: { id: auction.id }

        expect(assigns(:auction)).to eq auction
      end
    end

    describe "PATCH #save" do
      it "should redirect to root page if unauthorized" do
        auction = Auction.create!(name: 'MacBook')
        patch :save, params: { id: auction.id }
        expect(response).to redirect_to(root_path)
      end

      it "should raise error if cannot find id" do
        subject.current_user.role = 1
        expect { patch :save, params: { id: 10000 } }.to raise_error ActiveRecord::RecordNotFound
      end

      it "should update auction with valid params" do
        subject.current_user.role = 1
        auction = Auction.create!(name: 'MacBook')

        expect(auction.name).to eq 'MacBook'
        patch :save, params: { id: auction.id, auction: { id: auction.id, name: 'Mac', premium: false, photo: nil, finish_at: DateTime.now } }

        auction = Auction.find(auction.id)

        expect(auction.name).to eq 'Mac'
      end

      it "should render edit template with invalid params" do
        subject.current_user.role = 1
        auction = Auction.create!(name: 'MacBook')

        patch :save, params: { id: auction.id, auction: { name: nil, premium: false, photo: nil, finish_at: DateTime.now } }

        expect(response).to render_template(:edit)
      end
    end

    describe "DELETE :delete" do
      it "should redirect to root page if unauthorized" do
        auction = Auction.create!(name: 'MacBook')
        delete :delete, params: { id: auction.id }
        expect(response).to redirect_to root_path
      end

      it "should raise error with invalid id" do
        subject.current_user.role = 1
        expect { delete :delete, params: { id: 1000 } }.to raise_error ActiveRecord::RecordNotFound
      end

      it "should remove with valid id and redirect to auction list with flash message" do
        subject.current_user.role = 1
        auction = Auction.create!(name: 'MacBook')

        expect { Auction.find(auction.id) }.not_to raise_error

        delete :delete, params: { id: auction.id }

        expect { Auction.find(auction.id) }.to raise_error ActiveRecord::RecordNotFound
        expect(response).to redirect_to auctions_index_path
        expect(flash[:success]).to eq "Auction has been removed."
      end
    end

    describe "GET #bid" do
      it "should throw error with invalid id" do
        expect { get :bid, params: { id: 10000 } }.to raise_error ActiveRecord::RecordNotFound
      end

      it "should not be able to bid premium auctions without premium account" do
        auction = Auction.create!(name: 'MacBook', premium: true)
        get :bid, params: { id: auction.id }
        expect(response).to redirect_to root_path
      end

      it "should not be able to bid while being blocked" do
        subject.current_user.blocked = true
        auction = Auction.create!(name: 'MacBook')
        get :bid, params: { id: auction.id }
        expect(response).to redirect_to root_path
      end
      
      it "should not be able to bid with no money" do
        auction = Auction.create!(name: 'MacBook')
        get :bid, params: { id: auction.id }
        expect(response).to redirect_to auctions_index_path
        expect(flash[:danger]).to eq "Your balance is not enough."
      end

      it "should not be able to bid if auction has finished" do
        subject.current_user.balance = 0.14
        auction = Auction.create!(name: 'MacBook', finish_at: DateTime.now - 60.seconds)
        get :bid, params: { id: auction.id }
        expect(response).to redirect_to auctions_index_path
        expect(flash[:danger]).to eq "Auction is finished, you cannot bid."
      end
      
      it "should increase time of auction if it's less than 15seconds" do
        subject.current_user.balance = 0.14
        auction = Auction.create!(name: 'MacBook', finish_at: DateTime.now + 3.seconds)
        get :bid, params: { id: auction.id }
        auction = Auction.find(auction.id)
        expect(auction.finish_at).to be_within(2.seconds).of DateTime.now + 15.seconds
      end
      
      it "should increase auction price by $0.01" do
        subject.current_user.balance = 0.14
        auction = Auction.create!(name: 'MacBook', finish_at: DateTime.now + 60.seconds)
        last_price = auction.top_price
        get :bid, params: { id: auction.id }
        auction = Auction.find(auction.id)
        expect(auction.top_price).to eq (last_price + 0.01)
      end
      
      it "should create new bid" do
        subject.current_user.balance = 0.14
        auction = Auction.create!(name: 'MacBook', finish_at: DateTime.now + 60.seconds)
        get :bid, params: { id: auction.id }
        auction = Auction.find(auction.id)
        expect(auction.bids.find_by(price: auction.top_price)).not_to be_nil
      end
      
      it "should remove $0.01 from bidder balance" do
        subject.current_user.balance = 0.14
        last_balance = subject.current_user.balance
        auction = Auction.create!(name: 'MacBook', finish_at: DateTime.now + 60.seconds)
        get :bid, params: { id: auction.id }
        expect(subject.current_user.balance).to eq (last_balance - 0.01)
      end
      
    end

    describe "GET #wins" do
      it "should prepare auctions into @auctions" do
        a1, a2, a3, a4 =
          Auction.create!(name: 'MacBook', user: subject.current_user, finish_at: DateTime.now - 60.seconds),
          Auction.create!(name: 'iPhone', user: subject.current_user, finish_at: DateTime.now + 60.seconds),
          Auction.create!(name: 'iPad', user: subject.current_user, finish_at: DateTime.now - 70.seconds),
          Auction.create!(name: 'iWatch', finish_at: DateTime.now - 100.seconds)

        get :wins

        expect(assigns(:auctions)).to match_array [a1, a3]
      end
    end

    describe "GET #history" do
      it "should prepare bids into @bids" do
        auction = Auction.create!(name: 'MacBook')
        b1, b2, b3, b4 =
          subject.current_user.bids.create!(auction: auction, price: 3.20),
          subject.current_user.bids.create!(auction: auction, price: 1.20),
          subject.current_user.bids.create!(auction: auction, price: 8.13),
          subject.current_user.bids.create!(auction: auction, price: 10.21)

        get :history
        
        expect(assigns(:bids)).to match_array [b1, b2, b3, b4]
      end
    end

    describe "PATCH #pay" do
      it "should throw error with invalid id" do
        expect { patch :pay, params: { id: 10000 } }.to raise_error ActiveRecord::RecordNotFound
      end
      
      it "should not be able to pay paid auction" do
        auction = subject.current_user.auctions.create!(name: 'MacBook', finish_at: DateTime.now - 70.seconds, paid: true)
        patch :pay, params: { id: auction.id }
        expect(response).to redirect_to root_path
      end

      it "should not be able to pay auction that is not finished" do
        auction = subject.current_user.auctions.create!(name: 'MacBook', finish_at: DateTime.now + 70.seconds, paid: false)
        patch :pay, params: { id: auction.id }
        expect(response).to redirect_to root_path
      end

      it "should not be able to pay auction with not enough balance" do
        subject.current_user.balance = 29.99
        auction = subject.current_user.auctions.create!(name: 'MacBook', finish_at: DateTime.now - 70.seconds, paid: false, top_price: 30.00)
        patch :pay, params: { id: auction.id }
        expect(response).to redirect_to auctions_wins_path
        expect(flash[:danger]).to eq "Not enough balance."
      end

      it "should update user balance and redirect back to wins list" do
        subject.current_user.balance = 29.99
        auction = subject.current_user.auctions.create!(name: 'MacBook', finish_at: DateTime.now - 70.seconds, paid: false, top_price: 10.00)
        patch :pay, params: { id: auction.id }
        expect(subject.current_user.balance).to eq 19.99
        expect(flash[:success]).to eq "Auction has been paid. Your item is on the way."
        expect(response).to redirect_to auctions_wins_path
      end
    end

    describe "GET #shipping" do
      it "should redirect to root page if not authorized" do
        get :shipping
        expect(response).to redirect_to(root_path)
      end
      
      it "should return only auctions that are paid" do
        subject.current_user.role = 1
        a1, a2, a3 =
          Auction.create!(name: 'MacBook1', paid: true),
          Auction.create!(name: 'MacBook2', paid: false),
          Auction.create!(name: 'MacBook3', paid: true)

        get :shipping
        expect(assigns(:auctions)).to match_array [a1, a3]
      end
      
    end

    describe "PATCH #ship" do
      it "should throw error if invalid id" do
        expect { patch :ship, params: { id: 10000 } }.to raise_error ActiveRecord::RecordNotFound
      end
      
      it "should redirect to root page if not authorized" do
        auction = Auction.create!(name: 'MacBook1')

        patch :ship, params: { id: auction.id }

        expect(response).to redirect_to root_path
      end
      
      it "should redirect to shipping page if already shipped" do
        subject.current_user.role = 1
        auction = Auction.create!(name: 'MacBook1', shipped: true)

        patch :ship, params: { id: auction.id }

        expect(flash[:success]).to be_nil
        expect(response).to redirect_to auctions_shipping_path
      end
      
      it "should update auction shipped property" do
        subject.current_user.role = 1
        auction = Auction.create!(name: 'MacBook1')

        expect(auction.shipped).to be_falsey

        patch :ship, params: { id: auction.id }
        
        auction = Auction.find(auction.id)

        expect(auction.shipped).to be_truthy

        expect(flash[:success]).to eq "Auction has been set as shipped."
        expect(response).to redirect_to auctions_shipping_path
      end
      
    end

  end
end