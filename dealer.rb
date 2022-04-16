# frozen_string_literal: true

class Dealer < Player
  DEALER_LIMIT_POINTS = 17

  def info
    "#{name}: " + cards.map { '* ' }.join
  end

  def turn
    if count_points < DEALER_LIMIT_POINTS
      add_card
      return 'дилер берет карту...'
    end
    'дилер пропускает ход...'
  end
end
