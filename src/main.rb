#!/usr/bin/ruby
# frozen_string_literal: true

require '../lib/lib'

token = '5705470395:AAHg8fApmCRCe6Tk1dFuFNbq73yuEI2IQs0'
bd = []
maps = []
user1 = User.new(1)
user2 = User.new(2)
pve_bot = Player_bot.new(1)

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    bd.push([message.chat.id, 'start', 0]) if check_all(bd, message.chat.id).zero?
    case message.text
    when '/start'
      start(bd, bot, message)
    when 'Crosses', 'Noughts'
      set_crosses(bd, bot, message, maps, pve_bot) if message.text == 'Crosses'
      set_noughts(bd, bot, message, maps, pve_bot) if message.text == 'Noughts'
    when '/stop', 'No'
      stop(bot, bd, message, maps)
    when '/restart', 'Yes'
      restart(bot, bd, message, maps)
    when 'PVE', 'PVP'
      pve_setup(bd, bot, message) if message.text == 'PVE'
      pvp_setup(bd, bot, message, maps) if message.text == 'PVP'
    when '1', '2', '3', '4', '5', '6', '7', '8', '9'
      if check_status(bd, message.chat.id, 'pve') == 1
        pve_game(bd, bot, message, maps, pve_bot)
      elsif check_status(bd, message.chat.id, 'pvp') == 1
        pvp_game(bd, bot, message, maps, user1, user2)
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: 'Unknown command')
    end
  end
end
