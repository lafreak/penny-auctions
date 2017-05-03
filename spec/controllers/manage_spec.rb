require "rails_helper"

RSpec.describe ManageController, :type => :controller do
  describe "unauthenticated" do
    it "each action redirects to login page" do
      get :index 
      expect(response).to redirect_to(new_user_session_path)
      get :edit, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
      put :save, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
      delete :delete, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
      patch :block, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
      patch :role, params: { id: 1, role: 0 }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "unauthorized" do
    login_user

    it "each action redirects to root directory" do
      get :index 
      expect(response).to redirect_to(root_path)
      get :edit, params: { id: 1 }
      expect(response).to redirect_to(root_path)
      put :save, params: { id: 1 }
      expect(response).to redirect_to(root_path)
      delete :delete, params: { id: 1 }
      expect(response).to redirect_to(root_path)
      patch :block, params: { id: 1 }
      expect(response).to redirect_to(root_path)
      patch :role, params: { id: 1, role: 0 }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "authorized" do
    login_user

    describe "GET #index" do      
      it "loads all of the accounts into @users" do
        subject.current_user.role = 2
        
        user1, user2 = 
          User.create!(FactoryGirl.attributes_for(:user)), 
          User.create!(FactoryGirl.attributes_for(:user))

        get :index

        expect(assigns(:users)).to match_array([subject.current_user, user1, user2])
        expect(response).to render_template(:index)
      end
    end

    describe "GET #edit" do
      it "loads account into @user" do
        subject.current_user.role = 2
        user = User.create!(FactoryGirl.attributes_for(:user))

        get :edit, params: { id: user.id }

        expect(assigns(:user)).to eq user
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #save" do
      it "updates user with valid attributes and redirects to account list" do
        subject.current_user.role = 2
        user = User.create!(FactoryGirl.attributes_for(:user))

        put :save, params: { id: user.id, user: { name: 'Chris Brown', address: 'ul. Niepodległości', 
          email: 'newemail@gmail.com', balance: 39.99 } }

        actual = User.find(user.id)

        expect(actual.name).to eq 'Chris Brown'
        expect(actual.address).to eq 'ul. Niepodległości'
        expect(actual.email).to eq 'newemail@gmail.com'
        expect(actual.balance).to eq 39.99

        expect(response).to redirect_to(manage_index_path)
      end

      it "renders edit template with invalid attributes" do
        subject.current_user.role = 2
        user = User.create!(FactoryGirl.attributes_for(:user))

        put :save, params: { id: user.id, user: { name: 'Chris Brown', address: 'ul. Niepodległości', 
          email: 'newemailgmail.com', balance: 39.99 } }

          expect(response).to render_template(:edit)
      end
    end

    describe "DELETE #delete" do
      it "deletes user with certain id and redirects to account list" do
        subject.current_user.role = 2
        user = User.create!(FactoryGirl.attributes_for(:user))

        expect(User.find(user.id)).not_to be_nil
        delete :delete, params: { id: user.id }
        expect { User.find(user.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        expect(response).to redirect_to(manage_index_path)
      end
    end

    describe "PATCH #block" do
      it "sets opposite blocked value and redirects to account list" do
        subject.current_user.role = 2
        user = User.create!(FactoryGirl.attributes_for(:user))

        expect(user.blocked).to be_falsey
        patch :block, params: { id: user.id }
        expect(User.find(user.id).blocked).to be_truthy
        expect(response).to redirect_to(manage_index_path)
      end
    end
    
    describe "PATCH #role" do
      it "sets role value and redirects to account list" do
        subject.current_user.role = 2
        user = User.create!(FactoryGirl.attributes_for(:user))

        expect(user.role).to eq 0
        patch :role, params: { id: user.id, role: 1 }
        expect(User.find(user.id).role).to eq 1
        expect(response).to redirect_to(manage_index_path)
      end
    end
  end
end