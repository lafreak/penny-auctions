Rails.application.routes.draw do
  get 'auctions/index'
  get 'auctions/new'
  post 'auctions/create'
  get 'auctions/show/:id', to: 'auctions#show', as: 'auctions_show'
  get 'auctions/bid/:id', to: 'auctions#bid', as: 'auctions_bid'
  get 'auctions/edit/:id', to: 'auctions#edit', as: 'auctions_edit'
  patch 'auctions/save/:id', to: 'auctions#save'
  delete 'auctions/delete/:id', to: 'auctions#delete', as: 'auctions_delete'

  devise_for :users
  
  root 'static_pages#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
