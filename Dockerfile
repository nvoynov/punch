FROM ruby:3.0
WORKDIR /usr/src/app
ADD . /usr/src/app/
RUN bundle install
CMD ["/bin/sh"]
