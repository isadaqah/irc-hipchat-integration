An IRC bot that sends messages in an IRC channel to a HipChat Room. Useful for keeping IRC history, seeing messages in one place as well as collaboration in a support IRC channel.

How to install
------------
1. Clone repository.
2. Install requirements: `bundle install`.
3. Set environment variables:
    - `BOT_NICK` (*optional*): Defaults to `irc-hipchat-bot`
    - `COMPANY_LOGO` (*optional*): To display next to irc channel owners
    - **`HIPCHAT_AUTH_TOKEN`** (**required**): Hipchat authentication token
    - `HIPCHAT_ROOM` (*optional*): Hipchat room to echo messages, defaults to IRC
    - **`IRC_CHANNEL`** (**required**): IRC channel you want to monitor
    - `IRC_HOST` (*optional*): Defaults to `irc.freenode.net`
    - `IRC_PORT` (*optional*): Defaults to `6667`
    - `IRC_OWNERS` (*optional*): Comma separated list of IRC channel owners to highlight differently
    - `WORK_DAYS` (*optional*): Comma separated list of workdays. 0 is Sunday. Defaults to Mon-Fri. Used to prevent sending a notification if a user with an unanswered question rejoins the channel during a non-working day.
    - `WORK_HOURS` (*optional*): Work hours. Defaults to 9-18. Used to prevent sending a notification if a user with an unanswered question rejoins the channel during a non-working hour.
4. Run `irc-hipchat.rb`.

Note: Use `Dockerfile` if you'd like to run it in a docker contianer.

Features
------------
1. Highlights channel owners (different color and optional company logo)
2. Alerts when a user re-joins the channel if they asked a question during after hours, but no one was around to answer. (Beta)


License
------------
MIT License
