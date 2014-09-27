require 'cinch'
require 'hipchat'
require 'rinku'
require 'set'

BOT_NICK = ENV['BOT_NICK'].nil? ? 'irc-hipchat-bot' : ENV['BOT_NICK']
COMPANY_LOGO = ENV['COMPANY_LOGO']

HIPCHAT_AUTH_TOKEN = ENV['HIPCHAT_AUTH_TOKEN']
HIPCHAT_ROOM = ENV['HIPCHAT_ROOM'].nil? ? 'IRC' : ENV['HIPCHAT_ROOM']

IRC_CHANNEL = ENV['IRC_CHANNEL']
IRC_HOST = ENV['IRC_HOST'].nil? ? 'irc.freenode.net' : ENV['IRC_HOST']
IRC_PORT = ENV['IRC_PORT'].nil? ? '6667' : ENV['IRC_PORT']
IRC_OWNERS = ENV['IRC_OWNERS'].nil? ? Set.new : ENV['IRC_OWNERS'].split(',').to_set

WORK_DAYS = ENV['WORK_DAYS'].nil? ? [1,2,3,4,5] : ENV['WORK_DAYS'].split(',').map(&:to_i)

queue = Set.new
last_nick = nil
last_ts = 0

hipchat_client = HipChat::Client.new(HIPCHAT_AUTH_TOKEN, :api_version => 'v2')

bot = Cinch::Bot.new do
    configure do |c|
        c.server = IRC_HOST
        c.nick = BOT_NICK
        c.channels = [IRC_CHANNEL]
    end

    on :message do |m|
        # Build message
        nick = m.user.nick
        message = m.message
        is_owner = IRC_OWNERS.any? { |user| nick.include? user }
        show_logo = (is_owner && !COMPANY_LOGO.nil?)
        company_logo = (show_logo ? "<img src='#{COMPANY_LOGO}' height='16' width='16'/> " : "")
        hipchat_msg = "#{company_logo}<strong> #{nick}:</strong> #{message}"
        hipchat_msg = Rinku.auto_link(hipchat_msg, :urls)

        # Send message to Hipchat
        hipchat_client[HIPCHAT_ROOM].send('IRC',
            hipchat_msg,
            :notify => true,
            :color => (is_owner ? 'purple' : 'yellow'),
            :message_format => 'html')

        # Update after-hours queue
        if is_owner
            # Remove answered questions from queue
            queue.delete_if {|nick| message.include? nick }
            # Remove last unanswered question if answered within 30 mins
            if Time.now.to_i - last_ts < 30 * 60
                queue.delete(last_nick)
                last_nick = nil
                last_ts = 0
            end
        elsif IRC_OWNERS.any?
            # Queue question
            last_nick = nick
            last_ts = Time.now.to_i
            queue.add(nick)
        end
    end

    on :join do |m|
        # If no owners are configured, or not a work day --> donot alert on re-joins
        if IRC_OWNERS.any? && (WORK_DAYS.include? Time.now.wday)
            # Check if joining user has unanswered questions and some one
            # is available to reach out to them. If so then send an alert
            nick = m.user.nick
            has_unanswered_question = queue.include?(nick)
            support_online = hipchat_client[HIPCHAT_ROOM].get_room['participants']
            if support_online.length >= 3
                support_online.delete_if { |u|
                    presence = hipchat_client.user(u['id']).view.presence
                    !presence['is_online'] || !presence['show'].nil?
                }
                if has_unanswered_question && support_online.length >= 3
                    queue.delete(nick)
                    hipchat_client[HIPCHAT_ROOM].send('IRC',
                        "<strong>#{nick}</strong> asked a question during"\
                        " after hours, but no one was around to answer. They "\
                        " just joined #{IRC_CHANNEL} again, please reach "\
                        " out to them.",
                        :notify => true,
                        :color => "green",
                        :message_format => 'html')
                end
            end
        end
    end

    on :owner do |u|
        IRC_OWNERS.add(u.nick)
    end

    on :deowner do |u|
        IRC_OWNERS.delete(u.nick)
    end
end

bot.start
