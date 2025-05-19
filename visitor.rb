require_relative 'player'


class Visitor < Player
	def initialize(name)
		super(:visitor, name)
	end

	def calculate_points
		if cards_nominal.is_a?(Array)
			puts "cards_nominal = #{cards_nominal}"
			puts "Chose your points:"

			cards_nominal.each_with_index{|res, inx| puts "#{inx} - #{res}"}

			return cards_nominal[gets.chomp.to_i]

		else
			return cards_nominal

		end
	end

	def show_cards
		puts "Your cards: #{cards_on_hand.map(&:show).join(', ')}"
	end
end