require 'cinch'
require 'hipchat'
require 'rinku'
require 'set'

IRC_HOST = 'irc.freenode.net'
IRC_PORT = '6667'

HIPCHAT_AUTH_TOKEN = ENV['HIPCHAT_AUTH_TOKEN']
IRC_CHANNEL = ENV['IRC_CHANNEL']
HIPCHAT_ROOM = ENV['HIPCHAT_ROOM'].nil? ? 'IRC' : ENV['HIPCHAT_ROOM']
SUPER_USERS = ENV['SUPER_IRC_USERS'].nil? ? [] : ENV['SUPER_IRC_USERS'].split(',') # comma separated list of users to highlight in hipchat (e.g. company employees)
COMPANY_LOGO = ENV['COMPANY_LOGO']

queue = Set.new

hipchat_client = HipChat::Client.new(HIPCHAT_AUTH_TOKEN, :api_version => 'v2')

bot = Cinch::Bot.new do
    configure do |c|
        c.server = IRC_HOST
        c.nick = 'irc-hipchat'
        c.channels = [IRC_CHANNEL]
    end

    on :message do |m|
        nick = m.user.nick
        message = m.message
        is_super_user = SUPER_USERS.any? { |user| nick.include? user }
        if is_super_user
            queue.clear
        elsif SUPER_USERS.any?
            queue.add(nick)
        end
        company_logo = ((is_super_user && !COMPANY_LOGO.nil?) ? "<img src='#{COMPANY_LOGO}' height='16' width='16'/> " : "")
        hipchat_msg = "#{company_logo}<strong> #{nick}:</strong> #{message}"
        hipchat_msg = Rinku.auto_link(hipchat_msg, :urls)
        hipchat_client[HIPCHAT_ROOM].send('IRC',
            hipchat_msg,
            :notify => true,
            :color => (is_super_user ? 'purple' : 'yellow'),
            :message_format => 'html')
    end

    on :join do |m|
        if !SUPER_USERS.any?
            return
        end

        nick = m.user.nick
        has_unanswered_question = queue.include?(nick)
        support_is_online = hipchat_client[HIPCHAT_ROOM].get_room['participants'].length >= 3

        if has_unanswered_question && support_is_online
            queue.delete(nick)
            hipchat_client[HIPCHAT_ROOM].send('IRC',
                "<strong>#{nick}</strong> asked a question during after hours, but no one was around to help. They just joined #datadog again, please reach out to them.",
                :notify => true,
                :color => "red",
                :message_format => 'html')
        end
    end
end

bot.start