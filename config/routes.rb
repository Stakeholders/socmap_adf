Rails.application.routes.draw do
  # All adf routes
  namespace :adf do
    get "terms/index"
  end
end