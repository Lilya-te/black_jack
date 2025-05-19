# Константа дилера - 17
require_relative 'player'

class Diler < Player

	def initialize
		super(:diler, 'Diler')
	end

	def step
		if calculate_points >= Consts::DEALER_CRITIC_POINTS
			return :skip
		else
			return :ask_card
		end
	end

	def calculate_points
		if cards_nominal.is_a?(Array)
			result = cards_nominal.min
			cards_nominal.each { |nominal| result = [result, nominal].max if ((Consts::WIN_POINTS - nominal) > 0)  }
			return result

		else
			return cards_nominal

		end
	end

	def show_cards
		puts "Diler cards: #{cards_on_hand.map{"*"}.join}"
	end
end