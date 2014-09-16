require 'logger'
require 'em-irc'
require 'hipchat'

IRC_HOST = 'irc.freenode.net'
IRC_PORT = '6667'
HIPCHAT_ROOM = 'IRC'

HIPCHAT_AUTH_TOKEN = ENV['HIPCHAT_AUTH_TOKEN']
IRC_CHANNEL = ENV['IRC_CHANNEL']
SUPER_USERS = ENV['SUPER_IRC_USERS'].nil? ? [] : ENV['SUPER_IRC_USERS'].split(',') # comma separated list of users to highlight in hipchat (e.g. company employees)

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
      :color => (SUPER_USERS.include? source) ? 'green' : 'yellow', 
      :message_format => 'html')
  end
end

daemon.run!

