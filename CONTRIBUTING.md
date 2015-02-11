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

Contributor License Agreement
-----------------------------

Some legalese for contributions. By submitting a pull request to
[sep/ollert](https://github.com/sep/ollert), contributions contained
in that pull request will be bound to the CLA as defined below.

```
  Contributor License Agreement

  By submitting a pull request to the main repository at sep/ollert
  you are bound to this Individual Contributor License Agreement
  ("Agreement"). Except for the license granted in this Agreement to
  SEP and recipients of software distributed by SEP, You reserve all
  right, title, and interest in and to Your Contributions.

  1. Definitions

     "You" or "Your" shall mean the copyright owner or the individual
     authorized by the copyright owner that is entering into this
     Agreement with SEP.

     "Contribution" shall mean any original work of authorship,
     including any modifications or additions to an existing work, that
     is intentionally submitted by You to SEP for inclusion in,
     or documentation of, any of the products owned or managed by
     SEP ("Work"). For purposes of this definition, "submitted"
     means any form of electronic, verbal, or written communication
     sent to SEP or its representatives, including but not
     limited to communication or electronic mailing lists, source code
     control systems, and issue tracking systems that are managed by,
     or on behalf of, SEP for the purpose of discussing and
     improving the Work, but excluding communication that is
     conspicuously marked or otherwise designated in writing by You as
     "Not a Contribution."

  2. You Grant a Copyright License to SEP

     Subject to the terms and conditions of this Agreement, You hereby
     grant to SEP and recipients of software distributed by
     SEP, a perpetual, worldwide, non-exclusive, no-charge,
     royalty-free, irrevocable copyright license to reproduce, prepare
     derivative works of, publicly display, publicly perform,
     sublicense, and distribute Your Contributions and such derivative
     works under any license and without any restrictions.

  3. You Grant a Patent License to SEP

     Subject to the terms and conditions of this Agreement, You hereby
     grant to SEP and to recipients of software distributed by
     SEP a perpetual, worldwide, non-exclusive, no-charge,
     royalty-free, irrevocable (except as stated in this Section)
     patent license to make, have made, use, offer to sell, sell,
     import, and otherwise transfer the Work under any license and
     without any restrictions. The patent license You grant to
     SEP under this Section applies only to those patent claims
     licensable by You that are necessarily infringed by Your
     Contributions(s) alone or by combination of Your Contributions(s)
     with the Work to which such Contribution(s) was submitted. If any
     entity institutes a patent litigation against You or any other
     entity (including a cross-claim or counterclaim in a lawsuit)
     alleging that Your Contribution, or the Work to which You have
     contributed, constitutes direct or contributory patent
     infringement, any patent licenses granted to that entity under
     this Agreement for that Contribution or Work shall terminate as
     of the date such litigation is filed.

  4. You Have the Right to Grant Licenses to SEP

     You represent that You are legally entitled to grant the licenses
     in this Agreement.

     If Your employer(s) has rights to intellectual property that You
     create, You represent that You have received permission to make
     the Contributions on behalf of that employer, that Your employer
     has waived such rights for Your Contributions, or that Your
     employer has executed a separate Corporate Contributor License
     Agreement with SEP.

  5. The Contributions Are Your Original Work

     You represent that each of Your Contributions are Your original
     works of authorship (see Section 8 (Submissions on Behalf of
     Others) for submission on behalf of others). You represent that to
     Your knowledge, no other person claims, or has the right to claim,
     any right in any intellectual property right related to Your
     Contributions.

     You also represent that You are not legally obligated, whether by
     entering into an agreement or otherwise, in any way that conflicts
     with the terms of this Agreement.

     You represent that Your Contribution submissions include complete
     details of any third-party license or other restriction (including,
     but not limited to, related patents and trademarks) of which You
     are personally aware and which are associated with any part of
     Your Contributions.

  6. You Don't Have an Obligation to Provide Support for Your Contributions

     You are not expected to provide support for Your Contributions,
     except to the extent You desire to provide support. You may provide
     support for free, for a fee, or not at all.

  7. No Warranties or Conditions

     SEP acknowledges that unless required by applicable law or
     agreed to in writing, You provide Your Contributions on an "AS IS"
     BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER
     EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES
     OR CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, OR
     FITNESS FOR A PARTICULAR PURPOSE.

  8. Submission on Behalf of Others

     If You wish to submit work that is not Your original creation, You
     may submit it to SEP separately from any Contribution,
     identifying the complete details of its source and of any license
     or other restriction (including, but not limited to, related
     patents, trademarks, and license agreements) of which You are
     personally aware, and conspicuously marking the work as
     "Submitted on Behalf of a Third-Party: [named here]".

  9. Agree to Notify of Change of Circumstances

     You agree to notify SEP of any facts or circumstances of
     which You become aware that would make these representations
     inaccurate in any respect. Email us at legal@ollertapp.com.
```
