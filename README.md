# fitness

## Installation

### Local development (Linux)

1.  `$ sudo apt-get install libsqlite3-dev`
1.  `$ asdf install`
1.  `$ bundle install`
1.  `$ bin/rails s`

## Local development (Docker)

1.  `$ docker build -t fitness-dev .`
1.  `$ docker run -p 3000:3000 --rm fitness-dev`

For an interactive console:
1.  `$ docker run -it -p 3000:3000 --rm fitness-dev /bin/bash`
