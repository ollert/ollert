###Ollert

Author: Larry Price <larry@ollertapp.com>

Company: Software Engineering Professionals, Inc.

Website: [ollertapp.com](https://ollertapp.com)

####Description

Ollert is a data analysis tool for Trello.

####Development

Requirements

* ruby 2.1.0
* mongodb
* bundler

Use `bundle install` to install required gems.

Create a file called `.env` in the root project folder. Environment variables:

* PUBLIC_KEY
    * required
    * Retrieve a public key from Trello by visiting [https://trello.com/1/appKey/generate](https://trello.com/1/appKey/generate).
* SESSION_SECRET
    * optional
    * Any string.

Run `rake` to start the application on `localhost:4000`.
