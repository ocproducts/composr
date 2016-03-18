Welcome to the Composr unit testing framework.

This framework is designed to allow auto-runnable tests to easily be written for Composr. The advantage to this testing technique is once a test is written it can be re-run very easily -- being able to re-run a whole test set before each release will dramatically reduce the chance of new bugs creeping into releases, as tests would not pass in this circumstance. New bugs in new releases is always a problem for complex software like Composr, as it is a huge package and it's very easy to accidentally cause (and not notice) a new problem when fixing an old one.

Installation
------------

The files should be extracted to a Composr installation, under the directory '_tests'. They are not intended for use on a live site, and would cause problems if used this way (tests intentionally meddle with site contents to test it).

Make sure html_dump and anything in it has 777 permissions (full write permissions).

Running
-------

Simply call up http://yourbaseurl/_tests/index.php

From there you can choose to run tests that have been written.

Writing tests
-------------

Tests are stored under the '_tests/tests' directory, and are classed as either "regression tests" (tests written to illustrate a bug, that fail before we fix the bug, but pass after we fix the bug) or "unit tests" (a test designed to test some part of Composr).
At the time of writing there is only one test, unit_tests/forum.php, which serves as an example. Tests are PHP scripts, so a good understand if PHP is required to write them.

The testing framework is built around SimpleTest (http://www.simpletest.org/), so all their API can be used. We have extended it a little bit, so:
 - you can call up page-links
 - any pages loaded up are saved as HTML so you can check them via other means also (e.g. passing through an HTML validator, or checking them manually for aesthetic issues).
 - you can make Composr think you are a logged in administrator
 - there is some standard setUp/tearDown code should use for any test, to make sure Composr starts in a good state for testing (currently it just makes sure the site is not closed)
Read about the SimpleTest API on their website to understand what things like assertTrue mean, and what tools you have at your disposal.

Contributing
------------

We welcome any new tests you might want to write for us. We only have one at the moment and ideally we would have thousands, so there's a lot of work to do! The more tests we have, the more stable Composr will be.
Test writing can be fun, and doesn't take long if you already know programming. It's a great way to contribute in your free time without getting stuck in large projects.

If you've written some tests please post them in the addons forum and we'll grab them and add them to the repository we use for regular testing.
We hope other users will appreciate your efforts and give you some gift points to reward your work.
