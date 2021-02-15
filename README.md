# fitness

## Installation

### Local development (Linux)
1.  Start PostgreSQL via `$ docker run -p 5432:5432 --rm -e POSTGRES_DB=fitness_development -e POSTGRES_USER=fitness -e POSTGRES_PASSWORD=development postgres:13.2`
1.  `$ sudo apt-get install libpq-dev libsqlite3-dev`
1.  `$ asdf install`
1.  `$ bundle install`
1.  `$ yarn install`
1.  `$ bin/rails s`
1.  Navigate to [fitness app](https://localhost:3000)
1.  Make code changes
1.  Refresh browser
1.  Repeat (change, refresh, etc)

#### Debugging
1.  In the first terminal, interact with the debugger

### Local development (Skaffold + minikube)
1.  `$ asdf install`
1.  `$ minikube start`
1.  `$ skaffold dev --port-forward`
1.  Navigate to [fitness app](https://localhost:3000)
1.  Make code changes
1.  Refresh browser
1.  Repeat (change, refresh, etc)

#### Debugging
1.  In another terminal, run `$ kubectl attach -it fitness`
1.  Interact with debugger
1.  Detach by <kbd>Ctrl+P,Q</kbd>

### Local development (Docker)
1.  `$ docker-compose up`
1.  Navigate to [fitness app](https://localhost:3000)
1.  Make code changes
1.  Refresh browser
1.  Repeat (change, refresh, etc)

#### Debugging
1.  ???
