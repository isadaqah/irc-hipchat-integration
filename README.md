Sends messages in an IRC channel to a HipChat Room. Useful for keeping IRC history, and seeing messages in one place.

Getting Started
------------
1. Clone repository.
2. Install requirements: `bundle install`.
3. Set environment variable:
    - `HIPCHAT_AUTH_TOKEN` (*required*): Hipchat authentication token
    - `IRC_CHANNEL` (*required*): IRC channel You want to monitor
    - `SUPER_USERS` (*optional*): Comma separated list of users you want to highlight
    - `COMPANY_LOGO` (*optional*): To display next to super users in the chat.
4. Change IRC channel and Hipchat room names in `irc-hipchat.rb`.
5. Run `irc-hipchat.rb`.
