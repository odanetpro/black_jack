# frozen_string_literal: true

class ConsoleInterface
  def ask_name
    puts 'Добро пожаловать в казино! Как вас зовут?'
    gets.strip.capitalize
  end

  def show_game_field(players)
    puts
    players.each_value { |player| puts player.info }
  end

  def ask_human_turn
    loop do
      print "\n1 - пропустить, 2 - взять карту, 3 - открыть карты? "
      choice = gets.to_i

      return choice if (1..3).include?(choice)

      print "\nнеизвестное значение, повторите ввод..."
    end
  end

  def show_cards(players)
    puts
    players.each_value { |player| puts player.open_cards }
  end

  def ask_play_again?
    loop do
      print "\n\nСыграем еще раз? (д/н) "
      choice = gets.strip.downcase

      return choice == 'д' if %w[д н].include?(choice)

      print "\nнеизвестное значение, повторите ввод..."
    end
  end

  def show_players_bank(players)
    print 'В банке у игроков: '
    players.each_value { |player| print "#{player.name} - #{player.bank} " }
  end

  def show_message(message)
    puts message
  end
end
