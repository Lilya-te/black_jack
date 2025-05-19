# Общий класс для игроков
# Атрибут Тип игрока
# Содержит методы хода - пропуск, запрос карты, открытие карт.
# Атрибут balance
# Атрибут on_hand - карты на руках. Баланс карт.
require_relative 'consts'

class Player

	attr_reader :type, :name
	attr_accessor :balance, :cards_on_hand, :cards_points, :finish

	def skip
		# Game.next_step
	end

	# lambda finish? -> {return finish}


	def ask_card(deck)
		card = deck.give_card
		@cards_on_hand << card
	end

	def open
		@finish = true
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
    	return nominals_on_hand.sum if  nominals_on_hand.all?{ |item| item.is_a?(Integer) }

    	result_array = nil
		nominals_on_hand.each do |nominal|
			nominal = [nominal] if nominal.is_a?(Integer)
			result_array ||= nominal
			result_array = result_array.product(nominal).map(&:sum)
		end
		result_array.uniq
    end
end