require_relative 'card'

class Deck
	SUITS = %i[clovers pikes hearts tiles]
	VALUES = %i[2 3 4 5 6 7 8 9 10 jack queen king ace]

	def initialize
		@deck = SUITS.product(VALUES).map{|suit, value| Card.new(suit, value)}.shuffle
	end

	def give_card
		@deck.pop
	end

end