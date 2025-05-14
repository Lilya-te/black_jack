# Константа дилера - 17
require_relative 'player'

class Diler < Player

	CRITIC_POINTS = 17

	def initialize
		puts("!!!! Diler initialize")
		super(:diler, 'Diler')
	end
end