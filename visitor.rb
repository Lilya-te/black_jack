# frozen_string_literal: true

require_relative 'player'

class Visitor < Player
  def initialize(name)
    super(:visitor, name)
  end

  def calculate_points
    return cards_nominal unless cards_nominal.is_a?(Array)

    puts 'Chose your points:'

    cards_nominal.each_with_index { |res, inx| puts "#{inx} - #{res}" }
    cards_nominal[gets.chomp.to_i]
  end
end
