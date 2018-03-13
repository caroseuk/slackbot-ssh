#!/bin/sh
url="webhook_url_from_slack"
channel="#ssh-alerts"

if [ "$PAM_TYPE" != "close_session" ]; then
    host=$(curl icanhazptr.com)
    content="\"attachments\": [ { \"mrkdwn_in\": [\"text\",],\"text\": \"Someone Logged Into \`$host\`\", \"fields\": [ { \"title\": \"User\", \"value\": \"$PAM_USER\", \"short\": true }, { \"title\": \"IP Address:\", \"value\": \"<https://ipinfo.io/$PAM_RHOST | $PAM_RHOST>\", \"short\": true } ], \"color\": \"#F35A00\" } ]"
    curl -X POST --data-urlencode "payload={\"channel\": \"$channel\", \"mrkdwn\": true, \"username\": \"ssh-bot\", $content, \"icon_url\": \"http://www.dmuth.org/files/ssh.png\"}" $url
fi
