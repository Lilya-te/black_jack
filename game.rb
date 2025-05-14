# Ход игры
# Константы: Карты в игре, Свободные карты, Ставка сделана, Игрок чья очередь
# Метод старт

require_relative 'diler'
require_relative 'visitor'
require_relative 'deck'

class Game
	def start
		@diler = Diler.new
		puts "What is your name?"
		name = gets.chomp
		@visitor = Visitor.new(name)
		round
	end

	def round()
		# Сбросить карты диллера и гостя
		@diler.drop_round
		@visitor.drop_round
		# перемешать колоду
		deck = Deck.new
		@visitor.ask_card(deck.give_card)
		@diler.ask_card(deck.give_card)
		@visitor.ask_card(deck.give_card)
		@diler.ask_card(deck.give_card)

		puts "@visitor.cards_on_hand = #{@visitor.cards_on_hand}"
		puts "@diler.cards_on_hand = #{@diler.cards_on_hand}"
		# раздать по две карты
		# отобразить карты гостя, отобразить забрюленные карты диллера
		# положить в банк по 10 уе
		# отобразить баланс банка, баланс каждого гостя
		# Ход гостя

	end

	private


end