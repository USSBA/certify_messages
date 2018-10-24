# CertifyMessages

#### Table of Contents
- [Installation](#installation)
- [Usage](#usage)
    - [Conversations](#conversations)
    - [Messages](#messages)
- [Logging](#logging)
- [Development](#development)
- [Publishing](#user-content-publishing)
- [Changelog](#changelog)

This is a thin wrapper for the [Certify Messaging API](https://github.com/USSBA/message-api) to handle basic GET and POST operations for both conversations/threads and messages.

## Installation

There are three options you can use to install the gem. Pulling from the private sba-one gem server, building it manually, or installing directly from GitHub.

### Pulling from private geminabox (preferred)

Ensure you have the credentials configured with bundler, then add the following to your Gemfile:
```
source 'https://<domain-of-our-private-gem-server>/' do
  gem 'certify_documents'
end
```

### Install from GitHub

Add the following to your Gemfile to bring in the gem from GitHub:

```
gem 'certify_documents', git: 'git@github.com:USSBA/certify_documents.git', branch: 'develop' # Certify activity log service
```

This will pull the head of the develop branch in as a gem.  If there are updates to the gem repository, you will need to run `bundle update certify_documents` to get them.

### Building it manually

* Pull down the latest branch for the gem
* `bundle install` to build it
* You can run tests `rspec` to make sure it built okay.
* Then `rake build` to build the gem, this builds the .gem file in /pkg
* Jump over to the folder of the the app where you want to use them and follow the instructions below within that app/repo, for example, if working with the [Shared-Services Prototype](https://github.com/USSBA/shared-services-prototype):
  * Copy the .gem into the folder `vendor/gems/certify_documents`
  * In the app where you want to use the gem, do `gem install <path to gem>` e.g. `gem install vendor/gems/certify_documents/certify_documents-0.1.0.gem`
  * add `gem 'certify_documents'` to your Gemfile
  * `bundle install`
  * If this worked correctly, you should see `certify_documents` in your `Gemfile.lock`

### GemInABox

Having acquired the readtoken to the SBA geminabox server, add it to your bundle config via `bundle config geminabox.sba-one.net readtoken:readtoken`.

To relase a new version to geminabox, simply tag the repository with a tag in the form vX.Y.Z.  This will trigger an AWS CodeBuild process to build and deploy the gem to geminabox.

To use the gem from geminabox, add the following to your `Gemfile`:
```
group :ussba, :default do
  source 'https://geminabox.sba-one.net/' do
    gem 'certify_messages'
  end
end
```

### Install gem from GitHub

Alternatively, you can add the following to your Gemfile to bring in the gem from GitHub:

```
gem 'certify_messages', git: 'git@github.com:USSBA/certify_messages.git', branch: 'develop' # Certify messaging service
```

This will pull the head of the develop branch in as a gem.  If there are updates to the gem repository, you will need to run `bundle update certify_messages` to get them.

## Usage

### Configuration
Set the messages API URL in your apps `config/initializers` folder, you probably also want to include a `messages.yml` under `config` to be able to specify the URL based on your environment.

```
CertifyMessages.configure do |config|
  config.api_url = "http://localhost:3001"
  config.msg_api_version = 1
  config.excon_timeout = 5
  config.api_key = "your_api_key"
end
```
With [v1.2.0](CHANGELOG.md#120---2017-11-10), the default Excon API connection timeout was lowered to `20 seconds`. The gem user can also provide a timeout value in seconds as shown above in the `configure` block.  This value is used for the Excon parameters `connect_timeout`, `read_timeout`, and `write_timeout`.

The `api_key` is currently unused, but we anticipate adding in an API Gateway layer in the future.

### Conversations

#### Finding (GET) Conversations
* calling `CertifyMessages::Conversation.find({application_id: 1})` will query for all conversations for application_id = 1, returning an array of hashes
  * This also applies for subject, user_1, user_2, and id (aka conversation_id)
  * By default, archived conversations are not included.
    * To see only archived conversations, send `archived: true`
    * To see all conversations, send `include_archived: true`
* Calling the `.find` method with empty or invalid parameters will result in an error (see below)

#### Creating (POST) Conversation
* to create a new conversation:
```
  CertifyMessages::Conversation.create({
    user_1: <int>,
    user_2: <int>,
    application_id: <int>,
    subject: <string>
  })
```
  * This will return a JSON hash with a `body` containing the data of the conversation along with `status` of 201.

#### Creating a conversation with a message
```
  CertifyMessages::Conversation.create_with_message({
    user_1: <int>,
    user_2: <int>,
    application_id: <int>,
    subject: <string>,
    sender_id: <int>,
    recipient_id: <int>,
    body: <string>,
    priority_read_receipt: <boolean> (optional, default false)
  })
```
  * This will return a nested JSON hash for both the conversation and message:
  ```
  response:
    conversation:
      body: ...
      status: ...
    message:
      body: ...
      status: ...
  ```

#### Creating official conversation
To create an official conversation, you must pass in `conversation_type` of `official`

Example:
```
  CertifyMessages::Conversation.create({
    user_1: <int>,
    user_2: <int>,
    application_id: <int>,
    subject: <string>,
    conversation_type: 'official'
  })
```

#### [Un-]Archiving a conversation
To archive or un-archive a conversation, you must specify the `conversation_id`, and `archive`.  If `archive` is `true` the conversation will be archived. If `archive` is `false`, the conversation will be un-archived.

Example:
```
  CertifyMessages::Conversation.archive({
    conversation_id: <int>,
    archived: <boolean>
  })
```

#### Unread message counts
Given a comma-separated list of application ID's, and the ID of the message recipient, returns the number of unread messages on each application.

Example:
```
  CertifyMessages::Conversation.unread_message_counts({
    application_ids: "<int>,<int>,...",
    recipient_id: <int>
  })
```
Example response:
```
CertifyMessages::Conversation.unread_message_counts(application_ids: "1,2,3", recipient_id: 2)

{
  body: {
    "applications" => [{"application_id"=>1, "recipient_id"=>2, "unread_message_count"=>3},
                       {"application_id"=>2, "recipient_id"=>2, "unread_message_count"=>2}, {"application_id"=>3, "recipient_id"=>2, "unread_message_count"=>0}]
  },
  status: 200
}
```
### Messages
#### Finding (GET) Messages
* calling `CertifyMessages::Message.find({conversation_id: 1})` will query for all conversations for conversation_id = 1, returning an array of hashes
  * Combining the above with other parameters (e.g, subject, sender_id, will query messages within that thread)
* Calling the `.find` method with empty or invalid parameters will result in an error (see below)


#### Creating (POST) Messages
* to create a new message:
```
  CertifyMessages::Message.create({
    conversation_id: <int>,
    sender_id: <int>,
    recipient_id: <int>,
    body: <string>,
    priority_read_receipt: <boolean> (optional, default false)
  })
```
  * This will return a JSON hash with a `body` containing the data of the message along with `status` of 201.

#### Updating (PUT) Messages
* to update a message,for example to mark it as read:
```
  CertifyMessages::Message.update({
    conversation_id: <int>,
    id: <int>,
    read: true
  })
```
  * This will return a status of 204.


## Error Handling
* Calling a Gem method with no or empty parameters:
```
CertifyMessage::Conversation.where  {}
CertifyMessage::Conversation.find   {}
CertifyMessage::Conversation.create {}
CertifyMessage::Message.where       {}
CertifyMessage::Message.find        {}
CertifyMessage::Message.create      {}
CertifyMessage::Message.update      {}
```
will return a bad request:
`{body: "Bad Request: No parameters submitted", status: 400}`
* Calling a Gem method with invalid parameters:
```
CertifyMessage::Conversation.find   {foo: 'bar'}
CertifyMessage::Conversation.create {foo: 'bar'}
CertifyMessage::Message.find        {foo: 'bar'}
CertifyMessage::Message.create      {foo: 'bar'}
CertifyMessage::Message.update      {foo: 'bar'}
```
will return an unprocessable entity error:
`{body: "Unprocessable Entity: Invalid parameters submitted", status: 422}`
* Any other errors that the Gem experiences when connecting to the API will return a service error and the Excon error class:
`    {body: "Service Unavailable: There was a problem connecting to the messages API. Type: Excon::Error::Socket", status: 503}`

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
Use `rake console` to access the pry console and add the messages API URL to the gem's config to be able to correctly test commands:
```
  CertifyMessages.configuration.api_url = 'http://localhost:3001'
```
While working in the console, you can run `reload!` to reload any code in the gem so that you do not have to restart the console. Byebug is included for debugging and can be called by inserting `byebug` inline.

## Publishing
To release a new version:

  1. Bump the version in lib/\*/version.rb
  1. Merge into `master` (optional)
  1. Push a tag to GitHub in the form: `X.Y.Z` or `X.Y.Z.pre.myPreReleaseTag`

At this point, our CI process will kick-off, run the tests, and push the built gem into our Private Gem server.

## Changelog
Refer to the changelog for details on gem updates. [CHANGELOG](CHANGELOG.md)
