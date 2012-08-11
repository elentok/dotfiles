#!/bin/bash

echo "========================================"
echo "Installing Extra Gems"
echo "========================================"
gem install clipboard
gem install rspec
gem install irbtools 
gem install cucumber
gem install capybara
gem install debugger pry haml-rails guard-livereload guard-spork spork devise cancan paperclip guard
gem install rspec-rails jquery-rails jquery-ui-rails factory_girl_rails turn thin capistrano capistrano_colors 
gem install compass-rails simple_form simple_enum rb-fsevent bootstrap-sass bourbon jasmine jasminerice guard-jasmine
gem install uglifier sass-rails coffee-rails modernizr_rails backbone-on-rails

echo "========================================"
echo "Creating symbolic links"
echo "========================================"

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -sf "$DIR/irbrc" ~/.irbrc
ln -sf "$DIR/rdebugrc" ~/.rdebugrc

