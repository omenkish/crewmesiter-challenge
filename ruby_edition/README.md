# Prerequisites

1. Install Ruby
2. `gem install bundler`
3. `bundle install`

## Running Specs

`bundle exec rspec` or `bundle exec guard`

## Starting the Server
`rackup -p 3000`

## Asumptions

- I assumed that an employee cannot be on vacation and sick leave at the same time

- I didn't do much validation on the optional acceptance criteria. That means we are expected to provide correct values for the query. e.g 'http://localhost:3000/?startDate=2017-01-01&endDate=2018-12-01' is correct, but `http://localhost:3000/?startDate=2017-01-01&&endDate=2018-12-01` will fail

- My implementation for generating an ical file converts the data to ical format and writes it to a file

- To check if an employee is absent, I assume that we are comparing the absence endDate to the current time. This is very important as I implement the 3rd and 4th acceptance criteria based on this assumption.

- I implemented routing with `Rack` as I do not see the need to turn this to a rails or sinatra app.

- The rack section of the app can be greatly improved
