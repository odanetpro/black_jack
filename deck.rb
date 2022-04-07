# frozen_string_literal: true

class Deck
  def initialize
    @deck = []
    new_deck
  end

  def give_card
    @deck.pop
  end

  def new_deck
    %w[2 3 4 5 6 7 8 9 10 В Д К Т].each do |base|
      %w[♥ ♣ ♠ ♦].each do |suit|
        @deck << Card.new(base + suit, card_points(base))
      end
    end
    @deck.shuffle!
  end

  private

  def card_points(base)
    return 1 if base == 'Т'

    base.to_i.zero? ? 10 : base.to_i
  end
end
