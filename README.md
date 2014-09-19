Sends messages in an IRC channel to a HipChat Room. Useful for keeping IRC history, and seeing messages in one place.

Getting Started
------------
1. Clone repository.
2. Install requirements: `bundle install`.
3. Set `HIPCHAT_AUTH_TOKEN` and `IRC_CHANNEL` environment variable.
4. Change IRC channel and Hipchat room names in `irc-hipchat.rb`.
5. Run `irc-hipchat.rb`.
6. You can use god or supervisord to run process. Watch and configuration are provided for both.
