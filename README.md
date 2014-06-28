###Ollert

Author: Larry Price <larry@ollertapp.com>

Company: Software Engineering Professionals, Inc.

Website: [ollertapp.com](https://ollertapp.com)

####Description

Ollert is a data analysis tool for Trello.

####Development

Requirements

* ruby 2.1.2
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

All tests must pass before pushing to `origin/master`.

####Testing

All changes checked in to `origin/master` must be tested. There are two types of test: `spec` (unit tests) and cukes (acceptance tests).

To run the `spec` tests, use `rake test:spec`.

To run the cukes, use `rake test:cukes`.

To run all tests, use `rake test:all`.
