## SSH Slackbot

This is a simple slackbot to post successful SSH logins to a slack channel to help you keep track of server access. 

#### Step 1
Create an incoming [webhook](https://api.slack.com/incoming-webhooks) for your slack community.

#### Step 2
Create `/etc/ssh/sshslack.sh` 

#### Step 3
Place the following code into `/etc/ssh/sshslack.sh` and give the script execute permissions:

**Make sure to insert your Slack Webook URL and Channel name in the relevant variables at the top of the script.**

```bash
#!/bin/sh
url="webhook_url_from_slack"
channel="#ssh-alerts"

if [ "$PAM_TYPE" != "close_session" ]; then
    host=$(curl icanhazptr.com)
    content="\"attachments\": [ { \"mrkdwn_in\": [\"text\",],\"text\": \"Someone Logged Into \`$host\`\", \"fields\": [ { \"title\": \"User\", \"value\": \"$PAM_USER\", \"short\": true }, { \"title\": \"IP Address:\", \"value\": \"<https://ipinfo.io/$PAM_RHOST | $PAM_RHOST>\", \"short\": true } ], \"color\": \"#F35A00\" } ]"
    curl -X POST --data-urlencode "payload={\"channel\": \"$channel\", \"mrkdwn\": true, \"username\": \"ssh-bot\", $content, \"icon_url\": \"http://www.dmuth.org/files/ssh.png\"}" $url
fi

```
#### Step 4
Add the following line to `/etc/pam.d/sshd`:

`session optional pam_exec.so seteuid /etc/ssh/sshslack.sh`

#### Step 5
Test the new bot by logging into your server
![screenshot](https://cl.ly/1r2c0n0T191v/Image%202018-03-13%20at%209.59.13%20pm.png)
