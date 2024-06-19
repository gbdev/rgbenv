FROM ruby:latest

# https://github.com/infertux/bashcov/issues/43#issuecomment-1423015292

RUN gem install bashcov simplecov-lcov
RUN useradd -m bashcov

RUN apt-get update && \
    apt-get install -y libpng-dev pkg-config build-essential bison git curl

COPY . /rgbenv
WORKDIR /rgbenv
RUN chown -R bashcov:bashcov /rgbenv

USER bashcov

RUN make bats
RUN echo "require 'simplecov-lcov'" > .simplecov && \
    echo "SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter" >> .simplecov

CMD ["bash", ".github/ci/bashcov.sh"]


