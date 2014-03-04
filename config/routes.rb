OperationUmbra::Application.routes.draw do
  
  root :to => "games#index"

  get "/lobby" => "games#lobby"

  post "/join" => "games#join_game"

  get '/current_game' => "games#current_game"

  post '/leave_game' => "games#leave_game"

  post '/disband_game' => "games#disband_game"

  post '/start_game' => "games#start_game"

  resources :games

  devise_for :users

end

#                     root GET    /                              games#index
#                    games GET    /games(.:format)               games#index
#                          POST   /games(.:format)               games#create
#                 new_game GET    /games/new(.:format)           games#new
#                edit_game GET    /games/:id/edit(.:format)      games#edit
#                     game GET    /games/:id(.:format)           games#show
#                          PATCH  /games/:id(.:format)           games#update
#                          PUT    /games/:id(.:format)           games#update
#                          DELETE /games/:id(.:format)           games#destroy
#         new_user_session GET    /users/sign_in(.:format)       devise/sessions#new
#             user_session POST   /users/sign_in(.:format)       devise/sessions#create
#     destroy_user_session DELETE /users/sign_out(.:format)      devise/sessions#destroy
#            user_password POST   /users/password(.:format)      devise/passwords#create
#        new_user_password GET    /users/password/new(.:format)  devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format) devise/passwords#edit
#                          PATCH  /users/password(.:format)      devise/passwords#update
#                          PUT    /users/password(.:format)      devise/passwords#update
# cancel_user_registration GET    /users/cancel(.:format)        devise/registrations#cancel
#        user_registration POST   /users(.:format)               devise/registrations#create
#    new_user_registration GET    /users/sign_up(.:format)       devise/registrations#new
#   edit_user_registration GET    /users/edit(.:format)          devise/registrations#edit
#                          PATCH  /users(.:format)               devise/registrations#update
#                          PUT    /users(.:format)               devise/registrations#update
#                          DELETE /users(.:format)               devise/registrations#destroy





