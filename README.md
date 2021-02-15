# fitness

## Installation

### Local development (Linux)
1.  Start PostgreSQL via `$ docker run -p 5432:5432 --rm -e POSTGRES_DB=fitness_development -e POSTGRES_USER=fitness -e POSTGRES_PASSWORD=development postgres:13.2`
1.  Start Redis via `$ docker run -p 6379:6379 --rm redis:6.0`
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

#### Installing a Gem
1.  Open a new terminal
1.  Install gem via `$ bundle add <gem-name>`

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

#### Installing a Gem
1.  Get shell on pod via `$ kubectl exec -it fitness -- /bin/bash`
1.  Install gem via `$ bundle add <gem-name>`
1.  Exit out of shell via `$ exit`
1.  Copy changed files back to local repo via:
    1.  `$ kubectl cp fitness:/app/Gemfile ./Gemfile`
    1.  `$ kubectl cp fitness:/app/Gemfile.lock ./Gemfile.lock`

### Local development (Docker)
1.  `$ docker-compose up`
1.  Navigate to [fitness app](https://localhost:3000)
1.  Make code changes
1.  Refresh browser
1.  Repeat (change, refresh, etc)

#### Debugging
1.  Add `binding.pry` in code
1.  In another terminal, run `$ docker attach fitness_web`
1.  Interact with debugger
1.  Detach by <kbd>Ctrl+P,Q</kbd>

#### Installing a Gem
1.  Open a new terminal
1.  Get shell on web container via `$ docker-compose exec web bash`
1.  Install gem via `$ bundle add <gem-name>`
