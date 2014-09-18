God.watch do |w|
    w.name = "irc-hipchat"
    w.start = "ruby /home/vagrant/workspace/irc-hipchat-integration/irc-hipchat.rb"
    w.log = "irc-hipchat.log"
    w.keepalive
end
