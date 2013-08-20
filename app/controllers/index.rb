get '/' do
  # Look in app/views/index.erb
  redirect '/login' unless session[:user]
  github = Github.new login: "#{session[:user][:username]}", password: "#{session[:user][:password]}"
  @repos = github.repos.all per_page: 10
  @gists = github.gists.all per_page: 10
  activity = github.activity.events.user_performed user: "#{session[:user][:username]}"
  @activity = activity.select { |action| action.type == "PushEvent"}
  erb :index
end

get '/login' do
  erb :login
end

post '/login' do
  session[:user] = {username: params[:username], password: params[:password]}
  redirect '/'
end

get '/logout' do
  session[:user] = nil
  redirect '/'
end
