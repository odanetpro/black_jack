# frozen_string_literal: true

require './card'
require './deck'
require './player'
require './dealer'
require './black_jack'
require './console_interface'

interface = ConsoleInterface.new
black_jack = BlackJack.new(interface)
black_jack.play
