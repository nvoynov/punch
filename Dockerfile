FROM ruby:3.4.4 as build
WORKDIR /app
COPY Gemfile .
# COPY Gemfile.lock .
ENV BUNDLER_WITHOUT development test
RUN gem update --system && bundle install
ADD . .

FROM ruby:3.4.4
COPY --from=build /app /app
CMD ["/bin/app", "help"]
