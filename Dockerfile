FROM octohost/ruby-2.1.2

ADD . /srv/www

WORKDIR /srv/www

RUN bundle install

# NO_HTTP_PROXY

CMD ruby irc-hipchat.rb
