module AppsHelper

	def lastaction(op)
		if(op == 'D')
			'success'
		elsif(op == 'U')
			'alert'
		elsif(op == 'R')
			''
		end
	end
	def lastactiontext(op)
		if(op == 'D')
			'Deploy'
		elsif(op == 'U')
			'Undeploy'
		elsif(op == 'R')
			'Rollback'
		end
	end
end
