Contribute
==========

So you've got an awesome idea to throw into Ollert. Great! Please keep the
following in mind:

* **Contributions will not be accepted without tests or necessary documentation updates.**
* If you're creating a small fix or patch to an existing feature, just a simple
  test will do. Please stay in the confines of the current test suite.
* If it's a brand new feature, make sure to create a new
  [Cucumber](https://github.com/cucumber/cucumber/) feature and reuse steps
  where appropriate.
* Please try to match the existing style.
* Please do your best to submit **small pull requests**. The easier the proposed
  change is to review, the more likely it will be merged.
* When submitting a pull request, please make judicious use of the pull request
  body.

Test Dependencies
-----------------

You can run all the tests locally as described in the [README](/README.md). In order
for a pull request to be accepted, the [travis-ci build](https://travis-ci.org/sep/ollert)
__must__ be passing.

Workflow
--------

Here's the most direct way to get your work merged into the project:

* Fork the project.
* Clone down your fork ( `git clone git@github.com:<username>/ollert.git` ).
* Create a topic branch to contain your change ( `git checkout -b my_awesome_feature` ).
* Hack away, add tests. Not necessarily in that order.
* Make sure everything still passes by running `rake`.
* If necessary, rebase your commits into logical chunks, without errors.
* Push the branch up ( `git push origin my_awesome_feature` ).
* Create a pull request against sep/ollert and describe what your change
  does and the why you think it should be merged.

Finally...
----------

Thanks! Hacking on Ollert should be fun. If you find any of this hard to figure
out, let us know so we can improve our process or documentation!
