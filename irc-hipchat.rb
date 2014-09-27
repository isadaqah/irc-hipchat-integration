require 'cinch'
require 'hipchat'
require 'rinku'

IRC_HOST = 'irc.freenode.net'
IRC_PORT = '6667'

HIPCHAT_AUTH_TOKEN = ENV['HIPCHAT_AUTH_TOKEN']
IRC_CHANNEL = ENV['IRC_CHANNEL']
HIPCHAT_ROOM = ENV['HIPCHAT_ROOM'].nil? ? 'IRC' : ENV['HIPCHAT_ROOM']
SUPER_USERS = ENV['SUPER_IRC_USERS'].nil? ? [] : ENV['SUPER_IRC_USERS'].split(',') # comma separated list of users to highlight in hipchat (e.g. company employees)
COMPANY_LOGO = ENV['COMPANY_LOGO']

hipchat_client = HipChat::Client.new(HIPCHAT_AUTH_TOKEN, :api_version => 'v2')

bot = Cinch::Bot.new do
  configure do |c|
    c.server = IRC_HOST
    c.nick = 'irc-hipchat'
    c.channels = [IRC_CHANNEL]
  end

  on :message do |m|
    source = m.user.nick
    message = m.message
    is_super_user = SUPER_USERS.any? { |user| source.include? user }
    company_logo = ((is_super_user && !COMPANY_LOGO.nil?) ? "<img src='#{COMPANY_LOGO}' height='16' width='16'/> " : "")
    hipchat_msg = "#{company_logo}<strong> #{source}:</strong> #{message}"
    hipchat_msg = Rinku.auto_link(hipchat_msg, :urls)
    hipchat_client[HIPCHAT_ROOM].send('IRC', 
      hipchat_msg,
      :notify => true, 
      :color => (is_super_user ? 'purple' : 'yellow'), 
      :message_format => 'html')
  end
end

bot.start
