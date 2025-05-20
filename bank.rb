# frozen_string_literal: true

# Константа ставки 10
# Методы: принять ставки, расчитать игроков ({1: 20, 2: 0})
class Bank
  attr_accessor :capital

  def initialize
    @capital = 0
  end

  def get_bets(players)
    players.each do |player|
      player.balance -= Consts::BET
      @capital += Consts::BET
    end
  end

  def count_winner(winners)
    prise = capital / winners.count
    winners.each do |winner|
      winner.balance += prise
      @capital -= prise
    end
  end
end
