#!/bin/sh

Current_Version=1.2.0050
Year=$(date +"%Y")

home() {
  clear
  echo "=========================================================================="
  echo "                         $(basename $BASH_SOURCE)"
  echo "=========================================================================="
  echo ""
  echo "BPTechNet $(basename $BASH_SOURCE) version $Current_Version"
  echo "Copyright (c) 2000-$Year BP Technology Network"
  echo ""
  printf "Enter the domain abbreviation: "
  read DOMAIN
  echo ""
  echo "Domain Abbreviation: $DOMAIN"
  echo ""
  read -p "Is this the correct domain abbreviation (Y/N)? "
  [[ ! $REPLY =~ ^[Yy]$ ]] && home
  start
}

start() {
  clear
  echo "=========================================================================="
  echo "                         $(basename $BASH_SOURCE)"
  echo "=========================================================================="
  echo ""
  echo "BPTechNet $(basename $BASH_SOURCE) version $Current_Version"
  echo "Copyright (c) 2000-$Year BP Technology Network"
  echo ""
  printf "Enter the entity name: "
  read ENTITY
  echo ""
  echo "Entity Name: $ENTITY"
  echo ""
  read -p "Is this the correct entity (Y/N)? "
  [[ ! $REPLY =~ ^[Yy]$ ]] && start
  next
}

next() {
  clear
  echo "=========================================================================="
  echo "                         $(basename $BASH_SOURCE)"
  echo "=========================================================================="
  echo ""
  echo "BPTechNet $(basename $BASH_SOURCE) version $Current_Version"
  echo "Copyright (c) 2000-$Year BP Technology Network"
  echo ""
  echo ""
  printf "Enter the name of the project: "
  read PROJECT
  echo ""
  echo "Project Name: $PROJECT"
  echo ""
  read -p "Is this the correct PROJECT (Y/N)? "
  [[ ! $REPLY =~ ^[Yy]$ ]] && next
  step
}

step() {
  clear
  echo "=========================================================================="
  echo "                         $(basename $BASH_SOURCE)"
  echo "=========================================================================="
  echo ""
  echo "BPTechNet $(basename $BASH_SOURCE) version $Current_Version"
  echo "Copyright (c) 2000-$Year BP Technology Network"
  echo ""
  echo ""
  printf "Enter the name of the application: "
  read APPLICATION
  echo ""
  echo "Application Name: $APPLICATION"
  echo ""
  read -p "Is this the correct application (Y/N)? "
  [[ ! $REPLY =~ ^[Yy]$ ]] && step
  create
}

create() {
  echo off
  APPDIR=~/GITRepositories/$DOMAIN/$ENTITY/$PROJECT/trunk/$APPLICATION

  echo "Adding gems to Gemfile..."
cat <<EOT >> $APPDIR/Gemfile
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
EOT
  # "~/GITRepositories/$DOMAIN/$ENTITY/$PROJECT/trunk/$APPLICATION"
  echo "Running bundler..."
  cd $APPDIR
bundle install
  # "~/GITRepositories/$DOMAIN/$ENTITY/$PROJECT/trunk/$APPLICATION"
  echo "Importing style assets..."
mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.sass
sleep 10
cat <<EOT >> $APPDIR/app/assets/stylesheets/application.css.sass
@import "bootstrap-sprockets"
@import "bootstrap"
EOT
  # "~/GITRepositories/$DOMAIN/$ENTITY/$PROJECT/trunk/$APPLICATION"
  echo "Importing scripting assets..."
# cat <<EOT >> $APPDIR/app/assets/javascripts/application.js
# //= require bootstrap-sprockets
# //= require_tree .
#EOT
  SEARCH='//= require_tree .'
  REPLACE='//= require bootstrap-sprockets\n//= require_tree .'
# find . -type f -name '$APPDIR/assets/javascripts/application.js' -exec sed -i '' s/'//= require_tree .'/$IMPORT/ {} +
export LC_CTYPE=C LANG=C
find . -name '$APPDIR/assets/javascripts/application.js' -print0 | xargs -0 sed -i -e 's/$SEARCH/$REPLACE/g'
  # "~/GITRepositories/$DOMAIN/$ENTITY/$PROJECT/trunk/$APPLICATION"
  echo "Modifying layout..."
  SEARCH='<%= yield %>'
  REPLACE='    <div id="main-container" class="container">\n      <div class="row">\n        <div class="col-xs-3">\n          <h3>Tealeaf Academy Todo</h3>\n        </div>\n        <div class="col-xs-9">\n          <%= yield %>\n        </div>\n      </div>\n    </div>'
# find . -type f -name '$APPDIR/app/views/layouts/application.html.erb' -exec sed -i '' s/'<%= yield %>'/$LAYOUT/ {} +
find . -name '$APPDIR/app/views/layouts/application.html.erb' -print0 | xargs -0 sed -i -e 's/$SEARCH/$REPLACE/g'
  echo "Done!..."
}

if [ "$1" != "" ]; then
  DOMAIN="$1"
else
  home
fi

if [ "$2" != "" ]; then
  ENTITY="$2"
else
  start
fi

if [ "$3" != "" ]; then
  PROJECT="$3"
else
  next
fi

if [ "$4" != "" ]; then
  APPLICATION="$4"
else
  step
fi

create
