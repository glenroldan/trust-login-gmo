FROM ruby:3.0.4

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && \
  apt-get install -y vim curl nodejs yarn build-essential && \
  apt-get clean

RUN mkdir -p /app

WORKDIR /app

COPY Gemfile* /app

RUN gem install bundler && bundle install

COPY . /app

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
