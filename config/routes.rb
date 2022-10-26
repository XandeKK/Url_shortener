Rails.application.routes.draw do
  root 'home#index'
  post "shortener", to: "home#create"
end
