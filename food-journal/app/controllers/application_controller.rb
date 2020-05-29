require './config/environment'
require 'sinatra/base'
require 'rack-flash'


class ApplicationController < Sinatra::Base
  enable :sessions
  use Rack::Flash

  configure do
    set :session_secret, "secret"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    if logged_in?(session)
      redirect '/meals'
    else
    erb :home
    end
  end

  helpers do 
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @user ||= User.find(session[:user_id])
    end
  end

end
