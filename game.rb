# frozen_string_literal: true

require_relative 'consts'
require_relative 'bank'
require_relative 'diler'
require_relative 'visitor'
require_relative 'deck'

class Game
  OPTIONS = [{ id: 1, action: :ask_card, description: 'One more card, please.' },
             { id: 2, action: :skip, description: 'Skip.' },
             { id: 3, action: :open, description: 'Fin.' }].freeze

  def start
    @bank = Bank.new
    create_players

    lets_play = 'Y'
    while lets_play == 'Y'
      round
      break if game_over?

      puts 'One more? (Y/N)'
      lets_play = gets.chomp.upcase
    end
  end

  private

  def create_players
    @diler = Diler.new
    puts 'What is your name?'
    name = gets.chomp
    @visitor = Visitor.new(name)
  end

  def game_over?
    return false unless @visitor.balance.zero? || @diler.balance.zero?

    puts "#{@visitor.name} has ZERO balance" if @visitor.balance.zero?
    puts "#{@diler.name} has ZERO balance" if @diler.balance.zero?
    puts 'GAME IS OVER!'
    true
  end

  def round
    drop_players_cards
    show_balances

    first_dealt

    visitor_step
    unless @visitor.finish
      diler_step
      visitor_step unless @visitor.cards_on_hand.count == 3 && @diler.cards_on_hand.count == 3
    end

    calculate_result
    show_balances
  end

  def drop_players_cards
    @diler.drop_round
    @visitor.drop_round
  end

  def first_dealt
    @bank.get_bets([@diler, @visitor])
    @deck = Deck.new

    @visitor.ask_card(@deck)
    @diler.ask_card(@deck)
    @visitor.ask_card(@deck)
    @diler.ask_card(@deck)
  end

  def visitor_step
    show_visitor_cards
    puts 'It`s your turn! Chose one option:'
    print_visitor_options
    num = gets.chomp.to_i
    option = OPTIONS.find { |act| act[:id] == num }

    puts option[:description]
    player_step @visitor, option[:action]
  end

  def print_visitor_options
    OPTIONS.each do |item|
      printf "%-2<id>s %-30<action>s %<description>s\n",
             { id: item[:id], action: item[:action], description: item[:description] }
    end
  end

  def show_visitor_cards
    puts "Your cards: #{@visitor.show_cards}"
  end

  def show_diler_cards
    puts "Diler cards: #{@diler.show_cards}"
  end

  def open_cards
    show_visitor_cards
    show_diler_cards
  end

  def diler_step
    puts "Diler cards: #{@diler.hidden_cards}"
    action = @diler.step
    thinking
    puts "Diler chose #{action}"
    player_step @diler, action
  end

  def thinking
    printf 'Diler is thinking.'
    sleep 0.5
    printf '.'
    sleep 0.5
    printf '.'
  end

  def player_step(player, action)
    if action == :ask_card
      player.ask_card(@deck)
    else
      player.send(action)
    end
  end

  def calculate_result
    open_cards
    @visitor.open
    @diler.open
    show_cards_points

    @bank.count_winner complete_winner
  end

  def show_balances
    [@visitor, @diler].each do |player|
      printf "%-2<name>s %-30<balance>s\n", { name: player.name, balance: player.balance }
    end
  end

  def show_cards_points
    [@visitor, @diler].each do |player|
      printf "%-2<name>s %-30<cards_points>s\n", { name: player.name, cards_points: player.cards_points }
    end
  end

  def complete_winner
    return check_equal_result @visitor.cards_points if @visitor.cards_points == @diler.cards_points

    if diffs_product.zero?
      check_win_points
    elsif diffs_product.negative?
      check_different_sings
    else
      check_same_sings
    end
  end

  def diffs_product
    diler_diff * visitor_diff
  end

  def check_win_points
    diler_win if diler_diff.zero?
    visitor_win if visitor_diff.zero?
  end

  def check_different_sings
    visitor_win if diler_diff.negative?
    diler_win if visitor_diff.negative?
  end

  def check_same_sings
    if diler_diff.negative? && visitor_diff.negative?
      both_losers
    else
      check_positives
    end
  end

  def check_positives
    diler_diff > visitor_diff ? visitor_win : diler_win
  end

  def visitor_diff
    Consts::WIN_POINTS - @visitor.cards_points
  end

  def diler_diff
    Consts::WIN_POINTS - @diler.cards_points
  end

  def both_losers
    puts 'You both are losers'
    [@diler, @visitor]
  end

  def both_winners
    puts 'You both are winners!'
    [@diler, @visitor]
  end

  def visitor_win
    puts 'You are winner!'
    [@visitor]
  end

  def diler_win
    puts 'Diler wins!'
    [@diler]
  end

  def check_equal_result(points)
    points <= Consts::WIN_POINTS ? both_winners : both_losers
  end
end
