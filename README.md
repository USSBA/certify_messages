# CertifyMessages

This is a thin wrapper for the [Certify Messaging API](https://github.com/USSBA/message-api) to handle basic GET and POST operations for both conversations/threads and messages.

## Installation - *UNDER DEVELOPMENT*

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
* calling `CertifyMessages::Conversation.find({})` will query for all conversations, returning an array of hashes
* calling `CertifyMessages::Conversation.find({application_id: 1})` will query for all conversations for application_id = 1, returning an array of hashes
  * This also applies for subject, analyst_id, contributor_id, and id (aka conversation_id)
* Calling the `.find` method with invalid parameters will result in an error:
  * `CertifyMessages::Conversation.find({foo: 'bar'})` returns: `Invalid parameters submitted`

#### Creating (POST) Conversations
* to create a new conversation:
```
  CertifyMessages::Conversation.create({
    analyst_id: <int>,
    contributor_id: <int>,
    application_id: <int>,
    subject: <string>
  })
```
  * This will return a JSON hash with a `body` containing the data of the conversation along with `status` of 201.
* to create a conversation with a message:
```
  CertifyMessages::Conversation.create_with_message({
    analyst_id: <int>,
    contributor_id: <int>,
    application_id: <int>,
    subject: <string>,
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
* Calling the `.find` method with invalid parameters will result in an error:
  * `CertifyMessages::Message.find({foo: 'bar'})` returns: `Invalid parameters submitted`


#### Creating (POST) Messages
* to create a new message:
```
  CertifyMessages::Message.create({
    conversation_id: <int>,
    sender_id: <int>,
    recipient_id: <int>,
    subject: <string>
  })
```
  * This will return a JSON hash with a `body` containing the data of the message along with `status` of 201.

## Development
Use `bundle console` to access a console environment for testing development of the gem.
