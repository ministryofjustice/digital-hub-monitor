# The Digital Hub Monitoring

This application is used to setup and monitor the digital hub healthcheck dashboard.

The project is based on Smashing framework.



## Setup

Download the digital-hub-monitor repository and ensure you are in the correct top level file path before you proceed.

```
~/digital-hub-monitor
```


## Build

```
gem install bundler
bundle install
```

Ensure ruby dev and smashing is installed

```
apt-get install ruby-dev
gem install smashing
```


## Run

```
CIRCLE_CI_TOKEN="ENTER VALID API TOKEN" smashing start
```

## Local

Overview - http://localhost:3030/

## Heroku

https://thehub-monitor.herokuapp.com/circle

## Further Reading on Smashing

Check out http://smashing.github.io/ for more information.

## Deployment Configuration

Requires the following environment variables

- CIRCLE_CI_TOKEN - a valid circle API access token

## Dashboard Configuration

1. Edit dashboards/circle.erb to add projects to the build monitor
2. Edit the projects element in jobs/circle_ci.rb to match your changes to CI statuses shown in circle.erb
3. Edit the projects element in jobs/health.rb
