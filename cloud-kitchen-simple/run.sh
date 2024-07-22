#!/usr/bin/env bash
# vim: ft=bash

# Install BashMatic as a dependency
# At the end of the script, remove bashmatic.

echo "Please wait while we check and install all components..."

[[ -d ${HOME}/.bashmatic ]] || { 
  bash -c "$(curl -fsSL https://bit.ly/bashmatic-1-2-0)" 2>/dev/null
  trap "[[ -d ${HOME}/.bashmatic ]] && rm -rf ${HOME}/.bashmatic" EXIT
} 

unset DEBUG
source "${HOME}/.bashmatic/init.sh"

# header
hh() {
  echo
  h.blue "$@"
}

kitchen.deps.ruby() {
  inf "Checking Ruby Version..."
  
  local RUBY_MAJOR_VERSION=$(ruby -e 'puts RUBY_VERSION.split(".")[0..1].join.to_i')
  if [[ ${RUBY_MAJOR_VERSION} -lt 26 ]]; then
    not-ok:
    error "This project requires MRI Ruby version 2.6+ or 2.7+"
    exit 1
  fi

  inf " — phew, got Ruby ${RUBY_MAJOR_VERSION}"
  ok:
} 

kitchen.setup() {
  hh "installing Ruby Gem Dependencies..."
  run.set-all abort-on-error
  run "gem install bundler --version='2.1.4' || true"
  run "bundle check || bundle install"
}

kitchen.main() {
  h3 "Cloud Kitchen v1.0.0" 

  info "NOTE: If any of the following commands fails, the script aborts."

  kitchen.deps.ruby
  kitchen.setup

  hh "Running RSpec..."
  run.set-next show-output-on
  run "bundle exec rspec --format progress"

  hh "Running Rubocop..."
  run.set-next show-output-on
  run "bundle exec rubocop --format progress"

  echo
  hh "Starting the Kitchen Dispatcher..."

  info "To stop it, press Ctrl-C."

  trap 'exit 1' INT

  run.set-next show-output-on
  export DEBUG=true 
  run "bundle exec ./exe/kitchen spec/fixtures/orders.json"
} 

kitchen.main "$@"
