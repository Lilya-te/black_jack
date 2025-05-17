require_relative 'card'

class Deck
	SUITS = %w[clovers pikes hearts tiles]
	VALUES = %w[2 3 4 5 6 7 8 9 10 jack queen king ace]

	# SUITS = %w[clovers pikes hearts tiles]
	# VALUES = %w[2 ace]

	def initialize
		@deck = SUITS.product(VALUES).map{|suit, value| Card.new(suit, value)}.shuffle
	end

	def give_card
		@deck.pop
	end

end