D3out::Application.routes.draw do

  root :to => 'bdl_files#index'

  resources :bdl_files do
    get :polygons, :on => :member
    get :spaces, :on => :member
  end

  resources :instructions, :only => [:show]

end
