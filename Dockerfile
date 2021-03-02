FROM ruby:2.7.2
  
  # throw errors if Gemfile has been modified since Gemfile.lock
  # RUN bundle config --global frozen 1
  
RUN mkdir -p /usr/app
WORKDIR /usr/app
  
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
  
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
  
COPY Gemfile /usr/app/ 
  
  # Uncomment the line below if Gemfile.lock is maintained outside of build process
  # COPY Gemfile.lock /usr/app/
  
  
RUN bundle install
  
COPY . /usr/app
