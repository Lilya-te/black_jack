# Общий класс для игроков
# Атрибут Тип игрока
# Содержит методы хода - пропуск, запрос карты, открытие карт.
# Атрибут balance
# Атрибут on_hand - карты на руках. Баланс карт.
class Player

	attr_reader :type
	attr_accessor :balance, :cards_on_hand, :cards_points, :finish

	def skip
		# Game.next_step
	end

	def ask_card(card)
		cards_on_hand << card
		# calculate_points - метод должен быть описан внутри подклассов
	end

	def open
		finish = true
		# Game.next_step
	end

	def drop_round
		@cards_on_hand = []
		@cards_points = 0
		@finish = false
	end
    
    def initialize(type, name)
    	puts("Player type = #{type} name = #{name}")
		@type = type
		@name = name
		@balance = 100
		@cards_on_hand = []
		@cards_points = 0
		@finish = false
    end
end