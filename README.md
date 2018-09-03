# Generic Test Automation Framework
Ruby framework template for speeding up squads' test automation

## Installation
Dependencies:
- Ruby (> 2.4)
- _bundler_ gem

You will also need Cucumber:
```
gem install cucumber
```

Checkout the project and in project's main directory initialize the gemset for the project:
```
bundle install
```

Note that the _pg_ gem (for PostgreSql) may fail to install if you do not have PostgreSql client installation.
Windows users: in case you encounter SSL errors during the _bundle install_ command, refer to RUBY_SSL_WINDOWS_FAQ.MD for resolution.

## Setup
The configuration file `config\test_config.yml` does not contain any passwords you may need. Either set passwords as local environment variables (as in CI) or add them to the file, but DO NOT PUSH any passwords to GitHub;

The tests are set to run on Theta environment by default.


## Running tests
Run the whole suit on the default environment (Theta):
```
cucumber
```

Or specify another environment and run only tests for the API:
```
(Windows)
set TEST_ENV "staging"
cucumber features\features-api\merchant_test.feature

(MacOS)
TEST_ENV=staging cucumber features/features-api/merchant_test.feature
```

Or specify run only specific test suite:
```
(Windows)
cucumber features\features-api\merchant_test.feature

(MacOS)
cucumber features/features-api/merchant_test.feature
```
