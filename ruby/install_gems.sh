#!/bin/bash

# This script takes time (because "gem install" is very slow)
# so I moved to to a separate script

source `dirname $0`/../config.sh

install_gems() {
  gem_install rails
  gem_install nokogiri
  gem_install clipboard
  gem_install rspec
  gem_install irbtools 
  gem_install cucumber
  gem_install capybara
  gem_install debugger pry haml-rails guard-livereload guard-spork spork devise cancan paperclip guard
  gem_install rspec-rails jquery-rails jquery-ui-rails factory_girl_rails turn thin capistrano capistrano_colors 
  gem_install compass-rails simple_form simple_enum rb-fsevent bootstrap-sass bourbon jasmine jasminerice guard-jasmine
  gem_install uglifier sass-rails coffee-rails modernizr_rails backbone-on-rails
}

header "Gems"
install_gems
