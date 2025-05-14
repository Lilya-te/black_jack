class Card

	attr_reader :suit, :value

	def initialize(suit, value)
		@suit = suit
		@value = value
	end

	def nominal
		return [1, 11] if value == :ace
		
		return 10 if %i[jack queen king].include?(value)
		
		return value
	end
end