# frozen_string_literal: true

require './card'
require './deck'
require './player'

def start_new_game
  @game_con = 0
  @deck.new_deck

  @players.each_value do |player|
    player.new_game
    dealing(player)
    beting(player, GAME_BET)
  end
end

def dealing(player)
  2.times { player.add_card(@deck.give_card) }
end

def beting(player, bet)
  player.make_bet(bet)
  @game_con += bet
rescue RuntimeError => e
  puts e.message.to_s
  exit
end

def display_game_field
  puts
  @players.each_value do |player|
    player.dealer? ? show_hidden_player_info(player) : show_player_info(player)
  end
end

def show_player_info(player)
  puts "#{player.name}: #{player_cards(player)} Очки: #{player.count_points} "
end

def player_cards(player)
  player.cards.map(&:name).join(' ')
end

def show_hidden_player_info(player)
  print "#{player.name}: "
  player.cards.each { print '* ' }
end

def show_players_bank
  print 'В банке у игроков: '
  @players.each_value { |player| print "#{player.name} - #{player.bank} " }
end

def human_choice
  loop do
    print "\n\n1 - пропустить, 2 - взять карту, 3 - открыть карты? "
    choice = gets.to_i

    return choice if (1..3).include?(choice)

    print "\nнеизвестное значение, повторите ввод..."
  end
end

def computer_turn(player)
  if player.count_points < 17
    player.add_card(@deck.give_card)
    puts "\nдилер берет карту..."
  else
    puts "\nдилер пропускает ход..."
  end
end

def open_cards
  puts
  @players.each_value { |player| show_player_info(player) }
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

GAME_BET = 10
START_BANK = 100

@deck = Deck.new
@players = {}

puts 'Добро пожаловать в казино! Как вас зовут?'
@players[:user] = Player.new(gets.strip.capitalize, START_BANK, :user)
@players[:dealer] = Player.new('Дилер', START_BANK, :dealer)

loop do
  start_new_game

  loop do
    display_game_field

    # ход игрока
    case human_choice
    when 2
      @players[:user].add_card(@deck.give_card)
    when 3
      break
    end

    # ход компьютера
    computer_turn(@players[:dealer])

    break if three_cards?
  end

  open_cards
  summing_up
  show_players_bank

  exit unless play_again?
end
