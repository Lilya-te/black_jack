require_relative 'player'


class Visitor < Player
	def initialize(name)
		super(:visitor, name)
	end
end