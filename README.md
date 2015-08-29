# slack-todo-bot

Stoopid todo bot for Slack written in Racket

# Slack setup

* Add incoming webhook which you will specify in `config.rkt`
* Add two slash-commands
  * `/todo [text]`, which will trigger POST request to `http://yourhost:8000/add`
  * `/done [number]`, which will trigger POST request to `http://yourhost:8000/complete`
* Add outgoing webhook or slash-command, wich will be trigger POST(!) request to `http://yourhost:8000/broadcast`

# Installation

```
$ git clone https://github.com/semka/slack-todo-bot.git
$ cd slack-todo-bot
$ cp config.rkt.example config.rkt
<edit config.rkt to specify slack incoming hook>
$ sudo docker build .
$ sudo docker run -d -it <image-id>
```
Bot will be running on 8000 port.

After experiencing all this pain, try to have fun.
