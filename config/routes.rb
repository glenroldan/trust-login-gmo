Rails.application.routes.draw do
  namespace :api do
    resources :companies, only: [:create, :destroy] do
      resources :groups, only: [:create, :index], module: :company
    end



    resources :users, only: [:create] do
      resource :group, only: [] do
        post ':group_id' => 'users#assign_group', as: :assign
      end
    end
  end
end
