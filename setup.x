#!/bin/bash

REPOSITORY="https://raw.githubusercontent.com/TiuSh/trapd/main"
FILES=("Dockerfile" "docker-compose.yml")

print_status() {
  echo
  echo "## $1"
  echo
}

bail() {
  echo 'Error executing command, exiting'
  exit 1
}

exec_cmd_nobail() {
  echo "+ $1"
  bash -c "$1"
}

exec_cmd() {
  exec_cmd_nobail "$1" || bail
}

setup() {
  print_status "Downloading files"
  for file in "${FILES[@]}"; do
    exec_cmd "curl -sLf -O '$REPOSITORY/$file'"
  done

  print_status "Building the application"
  exec_cmd "docker compose build app"

  echo "What is your project named?"
  read app_name
  exec_cmd "docker compose run --rm -T app rails new /rails -n $app_name -d postgresql -m $REPOSITORY/template.rb"

  print_status "It's a trap!"
}

setup
