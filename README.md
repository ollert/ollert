### Ollert

Author: Larry Price <larry@ollertapp.com>

Company: Software Engineering Professionals, Inc.

Website: [ollertapp.com](https://ollertapp.com)

#### Description

Ollert is a data analysis tool for Trello.

#### Browser Support

Since Ollert depends entirely on Trello for users, Ollert will support only browsers supported by Trello. [Trello officially supports](//help.trello.com/customer/portal/articles/940690) the following browsers:

* Chrome - Current stable release
* Safari - Version 6.0 or higher
* Firefox - Current stable release
* Internet Explorer - Version 10.0 or higher

#### Development

You will want to install Ubuntu within a virtual machine for ease of development. There's an installation ISO available on `\\net\files\ISOs\OperatingSystems\Ubuntu` (if you're not sure, grab `ubuntu-12.04-server-amd64.iso`).

Once you get your VM running, you'll want to install the following packages:

    # sudo apt-get install libxslt-dev libxml2-dev build-essential libqtwebkit-dev

*Note*: You may need more packages. If you do, please edit this document and add them to the command above.

Requirements

* `ruby-2.1.2` - Install using [RVM](https://rvm.io/), be aware of [this issue](https://rvm.io/integration/gnome-terminal)
* `mongodb` - Check out [this very helpful page](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/)
* `bundler` - `gem install bundler`

In the project root folder, use `bundle install` to install required gems.

Create a file called `.env` in the root project folder. The format of the `.env` file is simply:

    ENVIRONMENT_VARIABLE=This is the value
	ANOTHER_VARIABLE=Another value

Environment variables:

* `PUBLIC_KEY`
    * required
    * Retrieve a public key from Trello by visiting [https://trello.com/1/appKey/generate](https://trello.com/1/appKey/generate).
* `TRELLO_TEST_USERNAME`
    * required
    * Username to use while running cukes
* `TRELLO_TEST_PASSWORD`
    * required
    * Password to use while running cukes
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

#### CI

Ollert has a [job set up in Jenkins](http://jenkins.net.sep.com/job/Ollert). This job runs all the tests. If your tests don't pass on the build server, they don't pass. No exceptions.
