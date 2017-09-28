# CertifyMessages

#### Table of Contents
- [Installation](#installation)
- [Usage](#usage)
    - [Conversations](#conversations)
    - [Messages](#messages)
- [Development](#development)
- [Changelog](#changelog)

This is a thin wrapper for the [Certify Messaging API](https://github.com/USSBA/message-api) to handle basic GET and POST operations for both conversations/threads and messages.

## Installation

### Building the Certify Messages Gem

This gem is a Ruby wrapper for the messaging API, allowing for cleaner code and calls for the [Messages Prototype app side](https://github.com/USSBA/message-prototype) of messaging.  Since this is still in dev, requiring `certify_messages` in the prototype requires a manual gem build (which is also documented on the messages prototype repo site):
* Pull down the latest branch for the gem
* `bundle install` to build it
* You can run tests `rspec` to make sure it built okay.
* Then `rake build` to build the gem, this builds the .gem file in /pkg
* Jump over to the folder of the the app where you want to use them and follow the instructions below within that app/repo, for example, if working with the [Messages Prototype](https://github.com/USSBA/message-prototype):
  * Copy the .gem into the folder `vendor/gems/certify_messages`
  * In the app where you want to use the gem, do `gem install <path to gem>` e.g. `gem install vendor/gems/certify_messages/certify_messages-0.1.0.gem`
  * add `gem 'certify_messages'` to your Gemfile
  * `bundle install`
  * If this worked correctly, you should see `certify_messages` in your `Gemfile.lock`

### Install gem from GitHub

Alternatively, you can add the following to your Gemfile to bring in the gem from GitHub:

```
gem 'certify_messages', git: 'git@github.com:USSBA/certify_messages.git', branch: 'develop' # Certify messaging service
```

This will pull the head of the develop branch in as a gem.  If there are updates to the gem repository, you will need to run `bundle update certify-messages` to get them.

## Usage

### Configuration
Set the messages API URL in your apps `config/initializers` folder, you probably also want to include a `messages.yml` under `config` to be able to specify the URL based on your environment.

```
CertifyMessages.configure do |config|
  config.api_url = "http://localhost:3001"
  config.msg_api_version = 1
end
```

### Conversations

#### Finding (GET) Conversations
* calling `CertifyMessages::Conversation.find({application_id: 1})` will query for all conversations for application_id = 1, returning an array of hashes
  * This also applies for subject, user_1, user_2, and id (aka conversation_id)
* Calling the `.find` method with empty or invalid parameters will result in an error (see below)

#### Creating (POST) Conversations
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
* to create a conversation with a message:
```
  CertifyMessages::Conversation.create_with_message({
    user_1: <int>,
    user_2: <int>,
    application_id: <int>,
    subject: <string>,
    sender_id: <int>,
    recipient_id: <int>,
    body: <string>
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
    body: <string>
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
CertifyMessage::Conversation.find   {}
CertifyMessage::Conversation.create {}
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

## Development
Use `rake console` to access the pry console and add the messages API URL to the gem's config to be able to correctly test commands:
```
  CertifyMessages.configuration.api_url = 'http://localhost:3001'
```
While working in the console, you can run `reload!` to reload any code in the gem so that you do not have to restart the console.

## Changelog
Refer to the changelog for details on gem updates. [CHANGELOG](CHANGELOG.md)
