get '/' do 

	if session[:player_id]
		@logged_in = logged_in?
		@current_player = current_player
	end

	erb :index
end

post '/players/new' do

	player = Player.new(params)

	if player.save
		session[:player_id] = player.id 
	end

	redirect '/'
end

post '/players' do 

	@player = Player.find_by(username: params[:username])

	if @player && @player.authenticate(params[:password_hash])
		session[:player_id] = @player.id
	end

	redirect '/'
end

get '/logout' do

	session[:player_id]=nil

	redirect '/'
	
end

post '/players/update' do
	p params
	if session[:player_id]

		@player = Player.find(session[:player_id])

		old_asteroids = @player.total_asteroids
		old_walls = @player.total_walls
		old_badguys = @player.total_badguys

		if params[:asteroids].to_i > @player.high_asteroids
			@player.update_attribute(:high_asteroids, params[:asteroids].to_i)
		end

		if params[:walls].to_i  > @player.high_walls
			@player.update_attribute(:high_walls, params[:walls].to_i)
		end

		if params[:kills].to_i  > @player.high_badguys
			@player.update_attribute(:high_badguys, params[:kills].to_i)
		end

		if params[:score].to_i  > @player.high_score
			@player.update_attribute(:high_score, params[:score].to_i)
		end

		@player.update_attribute(:total_asteroids, old_asteroids+params[:asteroids].to_i)
		@player.update_attribute(:total_walls, old_walls+params[:walls].to_i)
		@player.update_attribute(:total_badguys, old_badguys+params[:kills].to_i)

	end

end
