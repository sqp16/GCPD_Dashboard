Rails.application.routes.draw do

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/mydashboard', to: 'home#mydashboard', as: :mydashboard
  # get 'home/search', to: 'home#search', as: :search

  # Authentication routes
  resources :sessions
  resources :users
  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # Resource routes (maps HTTP verbs to controller actions automatically):
  resources :officers
  resources :units
  resources :investigations
  resources :crimes
  resources :criminals
  resources :crime_investigations

  # Routes for assignments
  get 'assignments/new', to: 'assignments#new', as: :new_assignment
  post 'assignments', to: 'assignments#create', as: :assignments
  patch 'assignments/:id/terminate', to: 'assignments#terminate', as: :terminate_assignment
  
  #Routes for suspects
  get 'suspects/new', to: 'suspects#new', as: :new_suspect
  post 'suspects', to: 'suspects#create', as: :suspects
  patch 'suspects/:id/remove', to: 'suspects#remove', as: :remove_suspect

  get 'investigation_notes/new', to: 'investigation_notes#new', as: :new_investigation_note
  post 'investigation_notes', to: 'investigation_notes#create', as: :investigation_notes
  # Toggle paths




  # Other custom routes
  get 'investigations/:id/investigation_notes', to: 'investigations#investigation_notes', as: :investigation_investigation_notes
  get 'investigations/:id/crime_investigations', to: 'investigations#crime_investigations', as: :investigation_crime_investigations
  patch 'investigations/:id/close', to: 'investigations#close', as: :close_investigation

  # Routes for searching
  get 'officers_search', to: 'officers#search', as: :officer_search
  get 'investigations_search', to: 'investigations#search', as: :investigation_search
  get 'criminals_search', to: 'criminals#search', as: :criminal_search

  # You can have the root of your site routed with 'root'
  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
