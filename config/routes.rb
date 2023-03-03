Rails.application.routes.draw do
  resources :students, only: [:index, :show, :destroy]
  resources :instructors do
    resources :students, only: [:create, :update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
