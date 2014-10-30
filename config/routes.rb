Rails.application.routes.draw do
  
  root to: "users#index"
  
  get '/users' => 'users#index', as: 'users'
  get '/users/create' => 'users#create', as: 'create_user'
  get '/users/email' => 'users#email', as: 'email_user'
  get '/users/login/:user_guid' => 'users#login', as: 'login_user'
  get '/users/logout' => 'users#logout', as: 'logout_user'
  get '/users/edit/:user_id' => 'users#edit', as: 'edit_user'
  get '/users/modify/:user_id' => 'users#modify', as: 'modify_user'
  
  get '/terms' => 'terms#index', as: 'terms'
  
  get '/comparitor' => 'comparitor#index', as: 'comparitor'
  
  get '/studies' => 'studies#index', as: 'studies'
  get '/studies/search' => 'studies#search', as: 'search_study'
  get '/studies/new' => 'studies#new', as: 'new_study'
  get '/studies/manage' => 'studies#manage', as: 'manage_study'
  get '/studies/show/:study_id' => 'studies#show', as: 'show_study'
  get '/studies/edit/:study_id' => 'studies#edit', as: 'edit_study'
  get '/studies/activate/:study_id/:n_way' => 'studies#activate', as: 'activate_study'
  get '/studies/publicize/:study_id' => 'studies#publicize', as: 'publicize_study'
  get '/studies/hide/:study_id' => 'studies#hide', as: 'hide_study'
  get '/studies/destroy/:study_id' => 'studies#destroy', as: 'destroy_study'
  get '/studies/add_to/:study_id' => 'studies#add_to', as: 'add_to_study'
  get '/studies/import_to/:study_id' => 'studies#import_to', as: 'import_to_study'
  get '/studies/remove_from/:study_id' => 'studies#remove_from', as: 'remove_from_study'
  get '/studies/export_items/:study_id' => 'studies#export_items', as: 'export_items_study'
  get '/studies/export_comparisons/:study_id' => 'studies#export_comparisons', as: 'export_comparisons_study'
  get '/studies/export_both/:study_id' => 'studies#export_both', as: 'export_both_study'
  
  get '/comparisons/assign/:study_id' => 'comparisons#assign', as: 'assign_comparison'
  get '/comparisons/show_two_way/:item_id1/:item_id2' => 'comparisons#show_two_way', as: 'show_two_way_comparison'
  get '/comparisons/show_three_way/:item_id1/:item_id2/:item_id3' => 'comparisons#show_three_way', as: 'show_three_way_comparison'
  get '/comparisons/two_way/:item_id1/:rank1/:item_id2/:rank2' => 'comparisons#two_way', as: 'two_way_comparison'
  get '/comparisons/three_way/:item_id1/:item_id2/:item_id3' => 'comparisons#three_way', as: 'three_way_comparison'
  
  get '*path' => redirect("/")
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
