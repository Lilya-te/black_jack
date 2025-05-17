# Ход игры
# Константы: Карты в игре, Свободные карты, Ставка сделана, Игрок чья очередь
# Метод старт

require_relative 'diler'
require_relative 'visitor'
require_relative 'deck'

class Game

	OPTIONS = [{ id: 1, action: :ask_card, description: 'One more card, please.' },
		{ id: 2, action: :skip, description: 'Skip.' },
		{ id: 3, action: :open, description: 'Fin.' }
	]

	def start
		@diler = Diler.new
		puts "What is your name?"
		name = gets.chomp
		@visitor = Visitor.new(name)
		lets_play = 'Y'
		while lets_play == 'Y'
			round
			puts 'One more? (Y/N)'
			lets_play = gets.chomp.upcase
		end
	end

	def round()
		drop_players_cards
		first_dealt

		puts "Your cards on hand #{@visitor.cards_on_hand}"
		puts "@diler.cards_on_hand = #{@diler.cards_on_hand}"
		# отобразить забрюленные карты диллера
		
		# положить в банк по 10 уе
		# отобразить баланс банка, баланс каждого гостя
		# Ход гостя
		visitor_step
		unless @visitor.finish
			diler_step
			visitor_step 
		end

		calculate_result
		complete_winner
		# update_bank
	end

	private

	def drop_players_cards
		@diler.drop_round
		@visitor.drop_round
	end

	def first_dealt
		@deck = Deck.new

		@visitor.ask_card(@deck)
		@diler.ask_card(@deck)
		@visitor.ask_card(@deck)
		@diler.ask_card(@deck)
	end

	def visitor_step
		puts "It`s your turn! Chose one option:"
		
		OPTIONS.each do |item|
	      printf "%-2<id>s %-30<action>s %<description>s\n",
	             { id: item[:id], action: item[:action], description: item[:description] }
	    end

		num = gets.chomp.to_i
		option = OPTIONS.find{|act| act[:id] == num}
		puts option[:description]
		player_step @visitor, option[:action]
	end

	def diler_step
		player_step @diler, @diler.step
	end

	def player_step player, action

		if action == :ask_card
			player.ask_card(@deck)
		else
			player.send(action)
		end

	end

	def calculate_result
		@visitor.open
		@diler.open
		puts "@visitor.cards_points = #{@visitor.cards_points}"
		puts "@diler.cards_points = #{@diler.cards_points}"
	end

	def complete_winner
		if @visitor.cards_points == @diler.cards_points 
			if @visitor.cards_points <= Consts::WIN_POINTS
				puts "You both are winners!"
			else
				puts "You both are losers"
			end
		else
			visitor_diff = Consts::WIN_POINTS - @visitor.cards_points
			diler_diff = Consts::WIN_POINTS - @diler.cards_points

			if diler_diff < 0 && visitor_diff < 0
				puts "You both are losers"
			elsif diler_diff < 0 && visitor_diff >= 0 
				puts "You are winner!"
			elsif diler_diff >= 0 && visitor_diff < 0 
				puts "Diler wines!"
			elsif diler_diff < visitor_diff
				puts "Diler wines!"
			else
				puts "You are winner!"
			end
		end
	end

end