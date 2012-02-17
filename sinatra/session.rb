class Session
	def initialize (user)
		@user = user
		@timeout = now()
	end
	
	def reset_timeout ()
		@timeout = now()
	end

	def timeout ()
		@timeout
	end

	def user()
		@user
	end
end
