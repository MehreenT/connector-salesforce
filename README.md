# SalesForce Connector

The aim of this connector is to implement data sharing between Connec! and SalesForce

### Configuration

Configure your SalesForce application. To create a new SalesForce application: http://geekymartian.com/articles/ruby-on-rails-4-salesforce-oauth-implementation/
export SALESFORCE_CLIENT_ID=
export SALESFORCE_CLIENT_SECRET=

Configure your Connec! API credentials. The application must be registered in Maestrano
export CONNEC_API_ID=
export CONNEC_API_KEY=

### Run the connector
rvm install jruby-9.0.1.0
gem install bundler
bundle
rails s -p3001