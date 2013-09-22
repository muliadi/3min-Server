ThreeminsServer::Application.routes.draw do
	devise_for :users

	root :to => "home#index"

	namespace :api, :defaults => { format: :json } do
		namespace :v1 do
			resources :users, :except => [:new, :edit] do
				collection do
					get :facebook
					get :existence
				end
			end

			resources :categories, :only => [:index, :show]

			resources :products, :except => [:new, :edit] do
				collection do
					get :details
					get :trending
				end
			end

			resources :transactions, :except => [:new, :edit, :destroy] do
				collection do
					get :buys
					get :sells
				end
			end
		end
	end
end
