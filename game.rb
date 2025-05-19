# Ход игры
# Константы: Карты в игре, Свободные карты, Ставка сделана, Игрок чья очередь
# Метод старт
require_relative 'consts'
require_relative 'bank'
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
		@bank = Bank.new
		puts "What is your name?"
		name = gets.chomp
		@visitor = Visitor.new(name)

		lets_play = 'Y'
		while lets_play == 'Y'
			round
			if @visitor.balance > 0 && @diler.balance > 0
				puts 'One more? (Y/N)'
				lets_play = gets.chomp.upcase
			else
				puts "#{@visitor.name} has ZERO balance" if @visitor.balance == 0
				puts "#{@diler.name} has ZERO balance" if @diler.balance == 0
				puts "GAME IS OVER!"
				lets_play = 'N'
			end
		end
	end

	def round()
		drop_players_cards

		@bank.get_bets([@diler, @visitor])
		first_dealt

		puts "@visitor.balance = #{@visitor.balance}"
		puts "@diler.balance = #{@diler.balance}"

		puts "!!! Your cards on hand #{@visitor.cards_on_hand.map(&:show)}"
		puts "!!! @diler.cards_on_hand = #{@diler.cards_on_hand.map(&:show)}"

		visitor_step
		unless @visitor.finish
			diler_step
			visitor_step 
		end

		calculate_result
		@bank.count_winner complete_winner
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
		winners = []
		if @visitor.cards_points == @diler.cards_points 
			if @visitor.cards_points <= Consts::WIN_POINTS
				puts "You both are winners!"
				winners = [@diler, @visitor]
			else
				puts "You both are losers"
				winners = [@diler, @visitor]
			end
		else
			visitor_diff = Consts::WIN_POINTS - @visitor.cards_points
			diler_diff = Consts::WIN_POINTS - @diler.cards_points

			if diler_diff < 0 && visitor_diff < 0
				puts "You both are losers"
				winners = [@diler, @visitor]
			elsif diler_diff < 0 && visitor_diff >= 0 
				puts "You are winner!"
				winners = [@visitor]
			elsif diler_diff >= 0 && visitor_diff < 0 
				puts "Diler wines!"
				winners = [@diler]
			elsif diler_diff < visitor_diff
				puts "Diler wines!"
				winners = [@diler]
			else
				puts "You are winner!"
				winners = [@visitor]
			end
		end

		winners
	end

end