# frozen_string_literal: true

class Dealer < Player
  def hidden_info
    "#{name}: " + cards.map { '* ' }.join
  end

  def turn
    if count_points < 17
      add_card
      return 'дилер берет карту...'
    end
    'дилер пропускает ход...'
  end
end
