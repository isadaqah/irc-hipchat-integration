An IRC bot that sends messages in an IRC channel to a HipChat Room. Useful for keeping IRC history, seeing messages in one place as well as collaboration in a support IRC channel.

How to install
------------
1. Clone repository.
2. Install requirements: `bundle install`.
3. Set environment variable:
    - `HIPCHAT_AUTH_TOKEN` (*required*): Hipchat authentication token
    - `IRC_CHANNEL` (*required*): IRC channel You want to monitor
    - `HIPCHAT_ROOM` (*optional*): Hipchat room to echo messages, defaults to IRC
    - `SUPER_USERS` (*optional*): Comma separated list of users you want to highlight
    - `COMPANY_LOGO` (*optional*): To display next to super users in the chat.
4. Change IRC channel and Hipchat room names in `irc-hipchat.rb`.
5. Run `irc-hipchat.rb`.


Features
------------
1. Highlights channel owners (different color and optional company logo)
2. Alerts when a user re-joins the channel if they asked a question during after hours, but no one was around to answer.


License
------------
MIT License



