require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class UsersController < ApplicationController
  
  get "/signup" do
    if Helpers.is_logged_in?(session)
        redirect '/meals'
    else
        erb :"/users/new"
    end
  end

  post "/signup" do
    if !!User.find_by(username: params["username"])
        flash[:username_error] = "Username already exists.  Please enter a different Username"
        redirect '/signup'
    end
    params.each do |label, input|
        if input.empty?
        flash[:sign_up_alert] = "All inputs required. Please fill out the #{label} field."
        redirect '/signup'
        end
    end
    @user = User.create(:username => params["username"], :email => params["email"], :password => params["password"])
    session[:user_id] = @user.id
    flash[:sign_up_message] = "Successfully Signed Up."
    redirect "/meals"
  end

  get "/login" do
    if Helpers.is_logged_in?(session)
        redirect '/meals'
    else
        erb :"users/login"
    end
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect "/meals"
    else
        flash[:login_error] = "Invalid Login. Please Try Again" 
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