# frozen_string_literal: true

# Константа дилера - 17
require_relative 'player'

class Diler < Player
  def initialize
    super(:diler, 'Diler')
  end

  def step
    return :skip if calculate_points >= Consts::DEALER_CRITIC_POINTS

    :ask_card
  end

  def calculate_points
    return cards_nominal unless cards_nominal.is_a?(Array)

    result = cards_nominal.min
    cards_nominal.each { |nominal| result = [result, nominal].max if (Consts::WIN_POINTS - nominal).positive? }
    result
  end

  def hidden_cards
    cards_on_hand.map { '*' }.join
  end
end
