Rails.application.routes.draw do

  root 'main#index'

  devise_for :users, controllers: {
      registrations: 'users/registrations'
  }

  devise_scope :user do
    get '/users/permit' => 'users/permit#permit'
    patch '/user/:id' => 'users/permit#update'
  end

  get 'tags/:tag' => 'articles#index', as: :tag

  get 'stats/:id' => 'articles#stats', as: :stats

  resources :user , :controller => 'users/permit', :action => 'permit_edit'

  resources :categories

  resources :pictures

  resources :articles

  resources :questions do
    put :upvote
    put :downvote
  end

  # devise_scope :users do
  #   get 'users/permit', to: 'users/registrations#index'
  #   match 'users/permit/:id', to: 'users/registrations#permit'
  # end

  # devise_scope :user do
  #   get 'admin/index/:id', to: 'devise/registrations', as: 'user'
  #   patch 'admin/index/:id', to: 'devise/registrations#update', as: 'user'
  # end

  # devise_for :users, :controllers => {:registrations => 'admin'}
  # resources :users



  # get 'admin/index' => 'devise/registerations#update'

  # devise_scope :user do
  #   get 'admin/index', as: 'user'
  #   patch 'admin/index' => 'devise/registrations#update'
  # end

  # patch "update" => "logged_customer#update"
  # match "admin/index"  => "devise/registerations#update", :via => :patch

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'articles#index'

  # get '/' => redirect('articles')

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
