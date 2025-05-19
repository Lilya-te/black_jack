# Общий класс для игроков
# Атрибут Тип игрока
# Содержит методы хода - пропуск, запрос карты, открытие карт.
# Атрибут balance
# Атрибут on_hand - карты на руках. Баланс карт.
require_relative 'consts'

class Player

	attr_reader :type
	attr_accessor :balance, :cards_on_hand, :cards_points, :finish

	def skip
		# Game.next_step
	end

	# lambda finish? -> {return finish}


	def ask_card(deck)
		card = deck.give_card
		@cards_on_hand << card
		show_cards
	end

	def open
		finish = true
		@cards_points = calculate_points
	end

	def drop_round
		@cards_on_hand = []
		@cards_points = 0
		@finish = false
	end
    
    def initialize(type, name)
		@type = type
		@name = name
		@balance = 100
		@cards_on_hand = []
		@cards_points = 0
		@finish = false
    end

    private

    def cards_nominal
    	nominals_on_hand = cards_on_hand.map(&:nominals)
    	if nominals_on_hand.any?{ |item| item.is_a?(Array) }
			result_array = nil
			nominals_on_hand.each do |nominal|
				nominal = [nominal] if nominal.is_a?(Integer)
				result_array ||= nominal
				result_array = result_array.product(nominal).map(&:sum)
			end
			result_array.uniq!
			return result_array
		else 
			nominals_on_hand.sum
		end
    end

    # def method_missing
    # 	puts "Something went wrong"
    # end
end