Rails.application.routes.draw do
  root 'home#index'
  post "shortener", to: "home#create"
  get "/:id", to: "home#redirect", as: "url_shortener"
end
