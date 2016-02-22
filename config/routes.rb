Rails.application.routes.draw do
  resources :plan, only: [:show, :index]
  root :to => "plan#index"
end
