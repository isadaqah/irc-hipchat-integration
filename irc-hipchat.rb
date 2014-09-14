require 'logger'
require 'em-irc'
require 'hipchat'

IRC_HOST = 'irc.freenode.net'
IRC_PORT = '6667'
IRC_CHANNEL = '#emacs'

hipchat_client = HipChat::Client.new(ENV['HIPCHAT_AUTH_TOKEN'], :api_version => 'v2')

daemon = EventMachine::IRC::Client.new do
  host IRC_HOST
  port IRC_PORT

  on(:connect) do
    nick('irc-hipchat')
  end

  on(:nick) do
    join(IRC_CHANNEL)
  end

  on(:message) do |source, target, message|
    hipchat_client['IRC'].send('IRC', 
      "<strong>#{source}:</strong> #{message}",
      :notify => true, 
      :color => 'yellow', 
      :message_format => 'html')
  end
end

daemon.run!

