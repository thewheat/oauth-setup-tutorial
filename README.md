# oauth-setup-tutorial
Simple Example of Setting up OAuth in Intercom

Full details at https://developers.intercom.com/docs/setting-up-oauth


# Setup
- Install Ruby version specified in .ruby-version via rbenv/rvm
- Switch to specific Ruby version
- Install Dependencies
```
bundle install
```
- Set up test public URL via ngrok
```
ngrok http 4567
```
- Create App https://app.intercom.com/a/apps/_/developer-hub
- Select "Use OAuth"
- Set Redirect URL to url provided by ngrok output and add /callback to the end e.g. `https://5c678b67.ngrok.io/callback`
- Code only requires the following Permission
   - Read one admin: View a single admin
- Save
- Go to "Configure > Basic Information" tab
   - Copy "Client ID" and replace `<CLIENT_ID>` in `server.rb` and `intercom.html`
   - Copy "Client Secret" and replace `<CLIENT_SECRET>` in `server.rb`
- Visit ngrok URL