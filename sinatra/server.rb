#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'json'
require 'guid'
require File.dirname(__FILE__)+'/session.rb'
require File.dirname(__FILE__)+'/config.rb'

set :public_folder, File.dirname(__FILE__) + '/static'

#room name => array of user names
users_by_room = Hash.new()
#user name => room name
room_by_user = Hash.new()
#session id => Session
sessions = Hash.new()

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

post '/login' do
	return '{error: "no username given"}' unless params[:user]
	guid = (Guid.new()).to_s()
	sessions[guid] = Session.new(params[:user])
	return {'session' => guid}.to_json()
end

post '/announce' do
	session = sessions[params[:session]]
	return '{"error": "invalid session"}' unless session
	users_by_room[room_by_user[session.user]].delete(session.user) if room_by_user[session.user]
	room = params[:room]
	room_by_user[session.user] = room
	users_by_room[room] = Array.new() unless users_by_room[room]
	users_by_room[room] << session.user
	session.reset_timeout()
	return true;
end

get '/users' do
	users_by_room.to_json()
end

get '/users/pretty' do
	users_by_room.map {|room, users|
		{"room" => room,
		 "users" => users}
	}.to_json()
end

get '/users/by-room/:room' do |room|
	users_by_room[room].to_json()
end

get '/rooms' do
	users_by_room.keys()
end

get '/users/:user' do |user|
	{'user' => user, 'room' => room_by_user[user]}.to_json()
end

#session purge logic: clears the session cache from stale sessions
def purge_sessions ()
	ref = Time.now()
	sessions.delete_if {|session|
		if session.timeout()+60*SESSION_TIMEOUT < ref then
			users_by_room[room_by_user[session.user]].delete(session.user)
			room_by_user.delete(session.user)
			return true
		end
		false
	}
end

Thread.new do
	purge_sessions
	sleep PURGE_INTERVAL
end
