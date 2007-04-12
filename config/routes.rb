ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  map.home '/discussion/', :controller => 'discussion', :action => 'index'
  # map.resources :forums, :controller => 'discussion'
  # map.resources :forums, :controller => 'discussion' do |forum|
    map.resources :topics, :controller => 'discussion' do |topic|
      topic.resources :posts
      # topic.resource :monitorship, :controller => :monitorships
    end
  # end
  
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  # map.connect 'admin/:controller/:action'
  # Install the default route as the lowest priority.
  # 
  map.connect '/', :controller => 'account', :action => 'login'
  map.connect ':controller/:action/:id'
end
