###Ollert

Author: Larry Price <larry@ollertapp.com>

Company: Software Engineering Professionals, Inc.

Website: [ollertapp.com](https://ollertapp.com)

####Description

Ollert is a data analysis tool for Trello.

####Browser Support

Since Ollert depends entirely on Trello for users, Ollert will support only browsers supported by Trello. [Trello officially supports](//help.trello.com/customer/portal/articles/940690) the following browsers:

* Chrome - Current stable release
* Safari - Version 6.0 or higher
* Firefox - Current stable release
* Internet Explorer - Version 10.0 or higher

####Development

Requirements

* ruby-2.1.2
* mongodb
* bundler
* libqtwebkit-dev

Use `bundle install` to install required gems.

Create a file called `.env` in the root project folder. Environment variables:

* PUBLIC_KEY
    * required
    * Retrieve a public key from Trello by visiting [https://trello.com/1/appKey/generate](https://trello.com/1/appKey/generate).
* SESSION_SECRET
    * optional
    * Any string.
* SENDGRID_USERNAME
    * optional
    * Sign up for [a free SendGrid account](https://sendgrid.com/user/signup)
    * On the Account Overview, find the "Username" field
* SENDGRID_PASSWORD
    * optional
    * Sign up for [a free SendGrid account](https://sendgrid.com/user/signup)
    * Whatever your password is when signing up

Run `rake` to start the application on `localhost:4000`.

All tests must pass before pushing to `origin/master`.

####Testing

All changes checked in to `origin/master` must be tested. There are two types of test: `spec` (unit tests) and cukes (acceptance tests).

To run the `spec` tests, use `rake test:spec`.

To run the cukes, use `rake test:cukes`.

To run all tests, use `rake test:all`.

####CI

(http://jenkins/job/Ollert)[http://jenkins/job/Ollert]

Runs all tests. If your tests don't pass on the build server, they don't pass. No exceptions.
