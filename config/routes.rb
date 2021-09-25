Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'




  resources :users do
    collection { post :import }
    member do
      get 'monthly_confirmation_info'
      patch 'approve_monthly_info'
      patch 'monthly_approve_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'employee'
      get 'attendances/user_log'
      patch 'update_confirmation'
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/change_month'
      patch 'attendances/change_approval'
    end
    resources :attendances, only: :update # この行を追加します。
  end

  resources :branch 
  post   '/branch/:id/edit', to: 'branch#update'

end
