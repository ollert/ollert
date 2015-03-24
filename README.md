### Ollert

[![Build Status](https://travis-ci.org/sep/ollert.svg?branch=master)](https://travis-ci.org/sep/ollert)


* Author: Larry Price <larry@ollertapp.com>
* Company: Software Engineering Professionals, Inc.
* Website: [ollertapp.com](https://ollertapp.com)
* License: [GNU Affero GPL v3.0](LICENSE)

#### Description

Ollert is a data analysis tool for Trello.

#### Browser Support

Since Ollert depends entirely on Trello for users, Ollert will support only browsers supported by Trello. [Trello officially supports](//help.trello.com/customer/portal/articles/940690) the following browsers:

* Chrome - Current stable release
* Safari - Version 6.0 or higher
* Firefox - Current stable release
* Internet Explorer - Version 10.0 or higher

#### Development

You almost certainly want to be using a Unix-based operating system. Some dependencies will be necessary before you can run the application. On Ubuntu:

``` bash
# sudo apt-get install libxslt-dev libxml2-dev build-essential libqtwebkit-dev
```

*Note*: You may need more packages. If you do, please edit this document and add them to the command above.

Requirements

* `ruby-2.2.0` - Install using [RVM](https://rvm.io/), be aware of [this issue](https://rvm.io/integration/gnome-terminal)
* `mongodb` - Check out [this very helpful page](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/)
* `bundler` - `gem install bundler`

In the project root folder, use `bundle install` to install required gems.

Create a file called `.env` in the root project folder. The format of the `.env` file is simply:

```
ENVIRONMENT_VARIABLE=This is the value
ANOTHER_VARIABLE=Another value
```

Environment variables:

* `PUBLIC_KEY`
    * required
    * Retrieve a public key from Trello by visiting [https://trello.com/1/appKey/generate](https://trello.com/1/appKey/generate).
* `TRELLO_TEST_DISPLAY_NAME`
    * required
    * Display name to use while running cukes (this is your `@<username>` from Trello)
* `TRELLO_TEST_USERNAME`
    * required
    * Username to use while running cukes
* `TRELLO_TEST_PASSWORD`
    * required
    * Password to use while running cukes
* `MEMBER_TOKEN`
    * required
    * this value is used to run the integration tests. To generate this value after you have entered your `PUBLIC_KEY` run the following command and paste the result into your `.env` file where it asks you to:
```
rake test:setup
```
* `SESSION_SECRET`
    * optional
    * Any string

Run `rake` to start the application on `localhost:4000`.

All tests must pass before pushing to `origin/master`.

#### Testing

All changes checked in to `origin/master` must be tested. There are two types of test: `spec` (unit tests) and cukes (acceptance tests).

To run the `spec` tests, use `rake test:spec`.

To run the cukes, use `rake test:cukes`. Cukes are run using the `TRELLO_TEST_USERNAME`. At least one test will fail if you have the improper boards. Create an organization "Test Organization 1" on Trello. Under "Test Organization", create two boards: "Test Board #1" and "Test Board #2". Additionally, create a general board called "Empty Board" and verify that the default "Welcome Board" is still visible to you. If "Welcome Board" is no longer available, you can simply create a new "Welcome Board" without any organization.

To run all tests, use `rake test:all`.

##### `testem`
The JavaScript specs use [`testem`](https://github.com/airportyh/testem#installation) as the test runner, which will require `nodejs`. To install (if you already have node) run the following command:

```
npm install testem -g
```

By default the tests will try to use [`PhantomJS`](http://phantomjs.org/) as the browser for the JavaScript specs. To install, PhantomJS needs to be part of your path. To install using Homebrew on OSX run the following command:

```
brew install phantomjs
```

#### CI
Travis CI is being used for CI. For clones of this repository, builds will run in your `https://travis-ci.org/<your username>/ollert` environment. Since the tests depend on the environment variables mentioned above, those also need to be carried over in your individual Travis CI setup. Please look at the documentation for [environment variables](http://docs.travis-ci.com/user/environment-variables/#Using-Settings) for more information about setting up your environment variables.

### Contributing

We want your help! Check out [CONTRIBUTING.md](/CONTRIBUTING.md) for advice on making contributions.
