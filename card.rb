class Card

	attr_reader :suit, :value

	def initialize(suit, value)
		@suit = suit
		@value = value
	end

	def nominals
		return [1, 11] if value == 'ace'
		
		return 10 if %w[jack queen king].include?(value)
		
		return value.to_i
	end

	def show
		"#{@value} #{Consts::CARD_SUITS[@suit.to_sym]}"
	end
end