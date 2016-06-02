Clock Tower
=============
[![Code Climate](https://codeclimate.com/github/lighthouse-labs/clock-tower/badges/gpa.svg)](https://codeclimate.com/github/lighthouse-labs/clock-tower) [![Test Coverage](https://codeclimate.com/github/lighthouse-labs/clock-tower/badges/coverage.svg)](https://codeclimate.com/github/lighthouse-labs/clock-tower/coverage)[![wercker status](https://app.wercker.com/status/716fce0af92b16f027bdee7950468aee/m "wercker status")](https://app.wercker.com/project/bykey/716fce0af92b16f027bdee7950468aee)

Initial version developed by Andre Soseilo.

### Getting Started

1. Clone the project
2. bundle install
3. Setup your config/database.yml based off config/database.example.yml
4. Setup a .env file based on .env.example in the project root
5. bin/rake db:setup
6. start server using bin/rails s

### Configuration
* [Sentry](https://getsentry.com) - Error reporting. Initial setup requires "SENTRY_DSN" .env variable set, /config/initializers/sentry.rb contains the configuration for the sentry-raven gem.

#### Clock Tower is an open-source time tracking web app.

The following specifies the features available for each user roles.

##### Project leaders:
* create projects
* preset task names
* look at tasks for all projects that he owns
* query/filter all tasks
* provide summary of tasks
* send out invitations to project members
* all tasks that project members can do

##### Project members:
* update profile
* create tasks for projects
* look at all tasks created
* query/filter all tasks
* provide summary of tasks
