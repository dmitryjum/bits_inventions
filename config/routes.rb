Rails.application.routes.draw do
  get 'inventions/index'
  get 'inventions/show'
  get 'inventions/update'
  get 'inventions/destroy'
  get 'inventions/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end


# Rails.application.routes.draw do
#   root to: 'apipie/apipies#index'
#   apipie
#   namespace :api do
#     namespace :v1 do
#       resources :schools, only: :index do
#         collection do
#           get :top_twenty_keys
#         end
#       end
#     end
#   end
# end
