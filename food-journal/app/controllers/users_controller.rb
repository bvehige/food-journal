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
    redirect "/meals"
  end

  get "/login" do
    erb :"users/login"
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect "/meals"
    else 
        erb :"/users/login"
    end

  end

  get "/logout" do
    if Helpers.is_logged_in?(session)
        session.clear
        redirect "/login"
    else
        redirect "/"
    end

  end

 
end