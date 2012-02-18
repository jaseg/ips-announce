class Session
	def initialize (user)
		@user = user
		@timeout = Time.now()
	end
	
	def reset_timeout ()
		@timeout = Time.now()
	end

	def timeout ()
		@timeout
	end

	def user()
		@user
	end
end
