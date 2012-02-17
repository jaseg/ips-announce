#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'json'
require 'guid'
require File.dirname(__FILE__)+'/session.rb'
require File.dirname(__FILE__)+'/config.rb'

#room name => array of user names
users_by_room = Hash.new()
#user name => room name
room_by_user = Hash.new()
#session id => Session
sessions = Hash.new()

get '/' do
	
end

post '/login' do
	sessions[Guid.new()] = Session.new(params[:user])
end

post '/announce' do
	session = sessions[params[:session]]
	if sessions[session] then
		room_by_user[session.user] = params[:room]
		session.reset_timeout()
	end
end

get '/users' do
	users_by_room.to_json()
end

get '/users/by-room/:room' do |room|
	users_by_room[room].to_json()
end

get '/rooms' do
	users_by_room.keys()
end

get '/user/:user' do |user|
	{'user' => user, 'room' => room_by_user[user]}.to_json()
end

#session purge logic: clears the session cache from stale sessions
def purge_sessions do
	ref = now()
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
