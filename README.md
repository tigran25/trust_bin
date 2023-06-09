# Trustbin - self-hosted, encrypted code snippet storage

Trustbin replaces public snippet sites like gist.github.com, pastebin and others
with a private, self-hosted version that keeps your teams code snippets private and
under your own control.

Trustbin was built for software teams like yours. You work on critical code, but
frequently need to share snippets between team members. Instead of relying on 
public cloud available services like gist, spin up your own instance of the private,
self-hosted alternative.

## Getting Started

The easiest, simplest way to get this running is by deploying directly to the DigitalOcean App Platform, which will create a scalable cluster with a database backend for you.  Note, this takes a few minutes:

[![Deploy to DO](https://www.deploytodo.com/do-btn-blue.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/scott/trust_bin/tree/master)

## Installing with Docker

Trustbin runs on Rails 7, Ruby 3 and uses Postgresql to store your snippets.  Run
Trustbin by cloning the repo and then using the docker compose to get up quickly.  Note
that these steps expect Compose v2:

Install Compose v2 if needed (Ubuntu):
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
apt-cache policy docker-ce
sudo apt install docker-ce -y
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
```

Clone the repo:
```
git clone https://github.com/scott/trust_bin.git
```

Copy .env.sample to .env and configure how you like.
```
cp .env.sample .env
```

Next build the container
```
docker compose build
```

Trustbin encrypts all of your code snippets. To do this, we first have to generate
some credentials and add them to the vault:
```
docker compose run --rm web bin/rails db:encryption:init
docker compose run --rm -e EDITOR=nano web bin/rails credentials:edit
```

Now create the database with
```
docker compose run --rm web bin/rails db:setup
```

Precompile assets
```
docker compose run --rm web bin/rails assets:precompile
```

Finally, run the app with
```
docker compose up -d
```

Log in for the first time with:
email: admin@test.com
password: 12345678

## MIT License

Copyright 2022, Scott Miller

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
