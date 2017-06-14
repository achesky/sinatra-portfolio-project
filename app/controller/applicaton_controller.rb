require '.config/environment'

class ApplicationController < Sinatra::Base

    configure do
      set :public_folder, 'public'
      set :views, 'app/views'
      enable :sessions
      set :session_secret, "bigbang"
    end


    get '/' do
      erb :index
    end

    post '/signup' do
      @student = Student.create(params)
      @session = session_secret
      @session[:id] = @student.id
      if is_logged_in? && !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
        redirect '/reviews'
      else
        redirect '/signup'
      end
    end

    get '/signup' do
      @session = session
      if is_logged_in?
        redirect '/reviews'
      else
        erb :'/students/create_student'
    end

    get '/login' do
      if is_logged_in?
        redirect '/reviews'
      else
        erb :'/students/login'
      end
    end
end
