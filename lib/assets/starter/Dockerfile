FROM ruby:3.2.2
WORKDIR /app
# COPY Gemfile Gemfile.lock .
# ENV BUNDLER_WITHOUT development test
# RUN gem update --system && bundle install
ADD . .
CMD ["ruby", "/app/exe/service.rb"]
