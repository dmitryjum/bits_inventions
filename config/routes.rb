Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resources :inventions do
          collection do
            delete :destroy_by_title
            patch :update_by_title
            get :by_bit_name
            get :where_bit_names
          end
        end
      end
    end
end