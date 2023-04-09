ARG RUBY_VERSION=3.2.2

FROM ruby:$RUBY_VERSION-slim

ARG RAILS_VERSION=7
ARG BUNDLER_VERSION=2
ARG NODE_VERSION=19
ARG PG_VERSION=15

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips gnupg2 curl git && \
    apt-get clean

# Add PostgreSQL to sources list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    . /etc/os-release && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $VERSION_CODENAME-pgdg main" $PG_VERSION > /etc/apt/sources.list.d/pgdg.list

# Install PostgreSQL
RUN apt-get update -qq && \
    apt-get install -y libpq-dev postgresql-client-$PG_VERSION && \
    apt-get clean

# Ensure node.js is available for apt-get
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -

# Install node and npm
RUN apt-get update -qq && apt-get install -y nodejs && npm install -g npm@$NPM_VERSION

# Mount $PWD to this workdir
WORKDIR /rails

# Ensure gems are installed on a persistent volume and available as bins
VOLUME /bundle
ENV PATH="/bundle/ruby/$RUBY_VERSION/bin:${PATH}"
ENV BUNDLE_PATH="/bundle"

# Install Bundler & Rails
RUN gem update --system && \
    gem uninstall bundler && \
    gem install bundler -v $BUNDLER_VERSION && \
    gem install rails -v $RAILS_VERSION

# Ensure binding is always 0.0.0.0, even in development, to access server from outside container
ENV BINDING="0.0.0.0"

# Overwrite ruby image's entrypoint to provide open cli
ENTRYPOINT [""]