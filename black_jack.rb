# frozen_string_literal: true

class BlackJack
  GAME_BET = 10
  START_BANK = 100

  def initialize
    @deck = Deck.new

    @players = {}

    puts 'Добро пожаловать в казино! Как вас зовут?'
    @players[:user] = Player.new(gets.strip.capitalize, START_BANK, GAME_BET, @deck)
    @players[:dealer] = Dealer.new('Дилер', START_BANK, GAME_BET, @deck)
  end

  def preparing
    @game_con = 0
    @deck = Deck.new

    @players.each_value do |player|
      player.new_game
      @game_con += GAME_BET
    end
  end

  def display_game_field
    puts
    @players.each_value { |player| puts player.dealer? ? player.hidden_info : player.info }
  end

  def show_players_bank
    print 'В банке у игроков: '
    @players.each_value { |player| print "#{player.name} - #{player.bank} " }
  end

  def human_choice
    loop do
      print "\n1 - пропустить, 2 - взять карту, 3 - открыть карты? "
      choice = gets.to_i

      return choice if (1..3).include?(choice)

      print "\nнеизвестное значение, повторите ввод..."
    end
  end

  def open_cards
    puts
    @players.each_value { |player| puts player.info }
  end

  def summing_up
    who_wins = winner

    if who_wins
      puts "\nПобедил #{who_wins.name}\n\n"
      who_wins.get_win(@game_con)
    else
      puts "\nНичья\n\n"
      @players.each_value { |player| player.get_win(@game_con / 2) }
    end
  end

  def winner
    players = @players.values.select { |player| player.count_points <= 21 }

    case players.size
    when 1
      players[0]
    when 2
      player_with_most_points(players)
    end
  end

  def player_with_most_points(players)
    return if players[0].count_points == players[1].count_points

    players[0].count_points > players[1].count_points ? players[0] : players[1]
  end

  def three_cards?
    @players.each_value { |player| return true if player.cards.size == 3 }
    false
  end

  def play_again?
    loop do
      print "\n\nСыграем еще раз? (д/н) "
      choice = gets.strip.downcase

      return choice == 'д' if %w[д н].include?(choice)

      print "\nнеизвестное значение, повторите ввод..."
    end
  end

  def game
    display_game_field

    # ход игрока
    case human_choice
    when 2
      @players[:user].add_card
    when 3
      return
    end

    # ход компьютера
    puts "\n#{@players[:dealer].turn}"

    three_cards? ? return : game
  end

  def play
    loop do
      preparing
      game
      open_cards
      summing_up
      show_players_bank
      exit unless play_again?
    end
  end
end
