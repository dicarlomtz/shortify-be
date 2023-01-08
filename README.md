# Shortify Backend

This project serves as an api backend for an url shortener.
This project can be used along this [frontend implentation](https://github.com/dicarlomtz/shortify-fe)

## Requirements
    - Docker Compose

## Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

## To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

## To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

## Run the web server

    docker-compose up

## Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/api/v1/urls

## Getting the top 100

    curl localhost:3000/api/v1/urls

## Checking your short URL redirect

    curl -I localhost:3000/abc
