require './config/environment'

class UsersController < ApplicationController

  get "/signup" do
    if !session[:user_id]
    erb :"/users/new"
    else
    redirect '/meals'
    end
  end

  post "/signup" do
    user = User.create(:username => params["username"], :email => params["email"], :password => params["password"])
    session[:user_id] = user.id
    redirect to '/meals'
  end

  get "/logout" do
    if Helpers.is_logged_in?(session)
        session.clear
        redirect '/login'
    else
        redirect '/'
    end

  end

 
end