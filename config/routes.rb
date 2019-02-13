Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resources :users, only: :create
        resources :inventions do
          collection do
            delete :destroy_by_title
            patch :update_by_title
            get :where_bit_names_are
            get :find_by_title
          end
        end
      end
    end
end