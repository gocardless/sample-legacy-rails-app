SampleRailsApp::Application.routes.draw do

  root :to => 'gocardless#index'

  get "gocardless/index"

  post "gocardless/buy"

  post "gocardless/subscribe"

  post "gocardless/preauth"

  get "gocardless/confirm"

  get "gocardless/success"

  get "gocardless/error"

  post "gocardless/webhook"

end
