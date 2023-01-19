FROM ruby:latest
WORKDIR /usr/src/app/
RUN bundle install
ADD . /usr/src/app/
EXPOSE 3333
CMD ["ruby", "/usr/src/app/hello.rb"]
