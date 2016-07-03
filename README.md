# slack-hipchat-bridge

>Cross-post messages between your slack and hipchat channels.

## Why?

Some people like Slack. Some people like HipChat. Why not share messages between them?

## Configuration

This application can be hosted on heroku.

To do so, simply create an app, and set each env variable in the sample
environment file in your heroku app (except PORT).

More about each variable:

* `LOG_DEBUG=false`
  * Do we want to log verbosely?
* `HIPCHAT_JID='<new-slack-user-id>@chat.hipchat.com'`
  * The user we will look for hipchat messages as.
* `HIPCHAT_PASSWORD='<new-user-password>'`
  * The password of the user we will look for messages as.
* `HIPCHAT_API_TOKEN='<new-user-generated-token>'`
  * The generated api v2 token used by the slack code to post messages to hipchat.
* `SLACK2HIPCHAT_ROOM_MAP='#slack-testing=@hipchat-testing,#general=@general'`
  * The mapping of slack room to hipchat room names.
* `SLACK_API_TOKEN='<new-slack-bot-api-token>'`
  * The token used for both the bot that listens to slack messages and for
    posting messages from hipchat to the slack api.
* `HEROKU_URL='https://my-app.herokuapp.com'`
  * Root url of the app, used for keeping it alive on one dyno.
* `PING_EVERY_SECONDS=30`
  * How frequently should we do a keep-alive GET requst on the app.

Currently, this only supports running on one dyno (or there will be duplicate responses in each channel).

After setting up your app environment, you should only have to push the repo to your app to
have it automatically build and deploy.

If you are able to successfully send messages between both your slack and hipchat instances, then
congratulations - you've successfully set it up!

## Contact and Issues

This code is still very much a work in progress. If you see any issues, please report them as a Github issue
(or try to fix them yourself an submit a merge request).
