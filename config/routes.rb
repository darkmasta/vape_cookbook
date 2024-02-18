Rails.application.routes.draw do

  scope '/api' do
    post '/signup', to: 'users#create'
    post '/login', to: 'sessions#create'

    resources :recipes do
      resources :comments

      member do
        post 'like'
      end
    end

    get '*path', to: redirect('/'), constraints: lambda { |req|
      !req.xhr? && req.format.html?
    }
  end

end
