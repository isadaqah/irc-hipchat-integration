require 'logger'
require 'em-irc'
require 'hipchat'

IRC_HOST = 'irc.freenode.net'
IRC_PORT = '6667'
HIPCHAT_ROOM = 'IRC'

HIPCHAT_AUTH_TOKEN = ENV['HIPCHAT_AUTH_TOKEN']
IRC_CHANNEL = ENV['IRC_CHANNEL']

hipchat_client = HipChat::Client.new(HIPCHAT_AUTH_TOKEN, :api_version => 'v2')

daemon = EventMachine::IRC::Client.new do
  host IRC_HOST
  port IRC_PORT

  on(:connect) do
    nick('irc-hipchat')
  end

  on(:nick) do
    join(ENV['IRC_CHANNEL'])
  end

  on(:message) do |source, target, message|
    hipchat_client[HIPCHAT_ROOM].send('IRC', 
      "<strong>#{source}:</strong> #{message}",
      :notify => true, 
      :color => 'yellow', 
      :message_format => 'html')
  end
end

daemon.run!

