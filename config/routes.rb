Rails.application.routes.draw do
  # All adf routes
  namespace :adf do
    resources :password_resets, :only => [:edit, :update]
  end
end