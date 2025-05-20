# frozen_string_literal: true

require_relative 'card'

class Deck
  def initialize
    @deck = suits.product(Consts::CARD_VALUES).map { |suit, value| Card.new(suit, value) }.shuffle
  end

  def give_card
    @deck.pop
  end

  private

  def suits
    Consts::CARD_SUITS.keys.map(&:to_s)
  end
end
