# CertifyMessages

This is a thin wrapper for the [Certify Messaging API](https://github.com/SBA-ONE/message-api) to handle basic GET and POST operations for both conversations/threads and messages.

## Installation - *UNDER DEVELOPMENT*

### Including the Certify Messages Gem

This gem is a Ruby wrapper for the messaging API, allowing for cleaner code and calls for the [Messages Prototype app side](https://github.com/SBA-ONE/message-prototype) of messaging.  Since this is still in dev, requiring `certify_messages` in the prototype requires a manual gem build (which is also documented on the messages prototype repo site):
* Pull down the latest branch for the gem
* `bundle install` to build it
* You can run tests `rspec` to make sure it built okay.
* Then `rake build` to build the gem, this builds the .gem file in /pkg
* Jump over to the folder of the prototype app
* In the Gemfile for the prototype App, change the local path for the `certify_messages` gem to the full path of where it is on your env.
* `bundle install` in the app repo
* If this worked correctly, you should see `certify_messages` with its own path at the top of your `Gemfile.lock`
* Start the API
* Start the App
* Calls from the App to the API will now go through the Gem, greatly reducing the code footprint in the App.

## Usage

### Configuration
Set the messages API URL in your apps `config/initializers` folder, you probably also want to include a `messages.yml` under `config` to be able to specify the URL based on your environment.

```
CertifyMessages.configure do |config|
  config.api_url = "http://foo.bar/"
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
* calling `CertifyMessages::Conversation.create({})

### Messages
*TODO*

## Development
Use `bundle console` to access a console environment for testing development of the gem.


