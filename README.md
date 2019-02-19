# CertifyMessages
Thin wrapper for the [Messages API](https://github.com/USSBA/message-api) to handle basic GET and POST operations for message entries.

#### Table of Contents
- [Installation](#user-content-installation)
- [Configuration](#user-content-configuration)
- [Methods](#user-content-methods)
- [Error Handling](#user-content-error-handling)
- [Logging](#user-content-logging)
- [Development](#user-content-development)
- [Publishing](#user-content-publishing)
- [Changelog](#user-content-changelog)

## Installation

### Pulling from private geminabox (preferred)

Ensure you have the credentials configured with bundler, then add the following to your Gemfile:
```
source 'https://<domain-of-our-private-gem-server>/' do
  gem 'certify_messages'
end
```

### Install from GitHub

Add the following to your Gemfile to bring in the gem from GitHub:

```
gem 'certify_messages', git: 'git@github.com:USSBA/certify_messages.git', branch: 'develop'
```

This will pull the head of the develop branch in as a gem.  If there are updates to the gem repository, you will need to run `bundle update certify_messages` to get them.

### Using it locally

* Clone this repository
* Add it to the Gemfile with the path:

```
gem 'certify_messages', path: '<path-to-the-gem-on-your-system>'
```

## Configuration
Within the host application, set the Certify Messages API URL in `config/initializers`, you probably also want to include a `messages.yml` under `config` to be able to specify the URL based on your environment.

```
CertifyMessages.configure do |config|
  config.api_key = "your_api_key"
  config.api_url = "http://localhost:3000"
  config.msg_api_version = 1
  config.excon_timeout = 5
end
```
The `api_key` is currently unused, but we anticipate adding in an API Gateway layer in the future.

With [v1.2.0](CHANGELOG.md#120---2017-11-10), the default Excon API connection timeout was lowered to `20 seconds`. The gem user can also provide a timeout value in seconds as shown above in the `configure` block.  This value is used for the Excon parameters `connect_timeout`, `read_timeout`, and `write_timeout`.

## Methods
Refer to the [Certify Messages API](https://github.com/USSBA/message-api) for more complete documentation and detailed examples of method responses.

Note: The Messages API has multiple versions that support different parameters. For example, v3 may require an `application_uuid` instead of an `application_id`. Refer to the API documentation to know which parameters to use depending on the version.

### Conversations
| Method | Description |
| ------ | ----------- |
| `CertifyMessages::Conversation.find({application_id: 1})` | Query for all conversations by `application_id`. This also applies for subject, user_1, user_2, and id. Conversations are organized in reverse chronological order by default. To change the order, pass in `order:'ascending'` with the request |
| `CertifyMessages::Conversation.create({ user_1: <int>, user_2: <int>, application_id: <int>, subject: <string> })` | Create a new conversation |
| `CertifyMessages::Conversation.create_with_message({ user_1: <int>, user_2: <int>, application_id: <int>, subject: <string>, sender_id: <int>, recipient_id: <int>, body: <string>, priority_read_receipt: <boolean> (optional, default false) })` | Create a conversation with a message |
| `CertifyMessages::Conversation.create({ user_1: <int>, user_2: <int>, application_id: <int>, subject: <string>, conversation_type: 'official' })` | Creating official conversation |
| `CertifyMessages::Conversation.archive({ conversation_id: <int>, archived: <boolean> })` | To archive or un-archive a conversation, you must specify the `conversation_id`, and `archive`.  If `archive` is `true` the conversation will be archived. If `archive` is `false`, the conversation will be un-archived. |
| `CertifyMessages::Conversation.unread_message_counts({ application_ids: "<int>,<int>,...", recipient_id: <int> })` | Given a comma-separated list of application ID's, and the ID of the message recipient, returns the number of unread messages on each application. |

### Messages
| Method | Description |
| ------ | ----------- |
| `CertifyMessages::Message.find({conversation_id: 1})` | Query for all conversations by conversation_id. Combining the above with other parameters (e.g, subject, sender_id), will query messages within that thread. Messages are returned in chronological order. To reverse the order, include the `order` parameter with 'ascending' |
| `CertifyMessages::Message.create({ conversation_id: <int>, sender_id: <int>, recipient_id: <int>, body: <string>, priority_read_receipt: <boolean> (optional, default false) })` | Create a new message |
| `CertifyMessages::Message.update({ conversation_id: <int>, id: <int>, read: true })` | Update a message. Ex. mark a message as read. |

## Error Handling

The Gem handles a few basic errors including:

* Bad Request - Raised when API returns the HTTP status code 400
* NotFound - Raised when API returns the HTTP status code 404
* InternalServerError - Raised when API returns the HTTP status code 500
* ServiceUnavailable - Raised when API returns the HTTP status code 503

Otherwise the gem will return more specific errors from the API. Refer to the API Docs for details around the specific error.

A typical error will look something like this:
```
{:body=>{"message"=>"No message found"}, :status=>404}
```

## Logging
Along with returning status error messages for API connection issues, the gem will also log connection errors.  The default behavior for this is to use the built in Ruby `Logger` and honor standard log level protocols.  The default log level is set to `debug` and will output to `STDOUT`.  This can also be configured by the gem user to use the gem consumer application's logger, including the app's environment specific log level.
```
# example implementation for a Rails app
CertifyMessages.configure do |config|
  config.logger = Rails.logger
  config.log_level = Rails.configuration.log_level
end
```

## Development
After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Use `bin/console` to access the pry console and add the API URL to the gem's config to be able to correctly test commands:
```
CertifyMessages.configuration.api_url="http://localhost:3000"
```
While working in the console, you can run `reload!` to reload any code in the gem so that you do not have to restart the console.  This should not reset the manual edits to the `configuration` as noted above.

## Publishing
To release a new version:

  1. Bump the version in lib/\*/version.rb
  1. Merge into `master` (optional)
  1. Push a tag to GitHub in the form: `X.Y.Z` or `X.Y.Z.pre.myPreReleaseTag`

At this point, our CI process will kick-off, run the tests, and push the built gem into our Private Gem server.

## Changelog
Refer to the [changelog](CHANGELOG.md) for details on API updates.
