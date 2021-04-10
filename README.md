# fitness

## Installation

### Local development (Linux)
1.  Start PostgreSQL via `$ docker run -p 5432:5432 --rm -e POSTGRES_DB=fitness_development -e POSTGRES_USER=fitness -e POSTGRES_PASSWORD=development postgres:13.2`
1.  Start Redis via `$ docker run -p 6379:6379 --rm redis:6.0`
1.  Install native dependencies via:
    - Ubuntu: `$ sudo apt-get install libpq-dev libsqlite3-dev`
    - Arch: `$ sudo pacman -Syu postgresql-libs sqlite`
1.  `$ asdf install`
1.  `$ bundle install`
1.  `$ yarn install`
1.  `$ bin/rails s`
1.  In another terminal, run `$ bin/sidekiq`
1.  In another terminal, run `$ bin/webpack-dev-server`
1.  Navigate to [fitness app](https://localhost:3000)
1.  Make code changes
1.  Refresh browser
1.  Repeat (change, refresh, etc)

#### Debugging
1.  In the first terminal, interact with the debugger

#### Installing a Gem
1.  Open a new terminal
1.  Install gem via `$ bundle add <gem-name>`

### Local development (DevSpace + Minikube)
1.  Install `devspace` CLI via:
    1.  `$ curl -s -L "https://github.com/devspace-cloud/devspace/releases/latest" | sed -nE 's!.*"([^"]*devspace-linux-amd64)".*!https://github.com\1!p' | xargs -n 1 curl -L -o devspace && chmod +x devspace;`
    1.  `$ sudo mv devspace /usr/local/bin;`
1.  `$ minikube start`
1.  Ensure GitHub Container Registry secret exists via: `kubectl create secret docker-registry devspace-auth-ghcr-io --docker-server=ghcr.io --docker-username=<USERNAME> --docker-password=<PERSONAL_ACCESS_TOKEN>`
1.  Run `$ devspace dev` to start development mode
1.  [fitness app](http://localhost:3000) will open automatically in browser
1.  Make code changes
1.  Refresh browser
1.  Repeat (change, refresh, etc)
1.  In the terminal window, run <kbd>Ctrl+C,Q</kbd> to stop development mode
1.  Run `$ devspace purge` to clean up resources

#### Debugging
1.  In another terminal, run `$ devspace attach -c fitness-web`
1.  Interact with debugger
1.  Detach by <kbd>Ctrl+P,Q</kbd>

#### Installing a Gem
1.  In another terminal, run `$ devspace enter -c fitness-web -- bundle add <gem-name>`

Gemfile changes will automatically sync back locally:
```
[0:sync:app] Downstream - Download file './Gemfile', uncompressed: ~2.25 KB
[0:sync:app] Downstream - Download file './Gemfile.lock', uncompressed: ~6.04 KB
[0:sync:app] Downstream - Successfully processed 2 change(s)
```

#### Running tests
1.  In another terminal, run `$ devspace enter -c fitness-web -- bin/rails test`

### Local development (DevSpace + Loft)
1.  Install `devspace` CLI via:
    1.  `$ curl -s -L "https://github.com/devspace-cloud/devspace/releases/latest" | sed -nE 's!.*"([^"]*devspace-linux-amd64)".*!https://github.com\1!p' | xargs -n 1 curl -L -o devspace && chmod +x devspace;`
    1.  `$ sudo mv devspace /usr/local/bin;`
1.  Install Loft plugin via `$ devspace add plugin https://github.com/loft-sh/loft-devspace-plugin`
1.  Follow [instructions](./cluster/README.md) to install Loft onto a minikube-based k8s cluster
1.  Log into Loft via `$ devspace login https://loft.noizwaves.cloud`
1.  [fitness app](http://localhost:3000) will open automatically in browser
1.  _"Do development"_
    1.  Make source code changes
    1.  Refresh browser
    1.  etc.
1.  In the terminal window, run <kbd>Ctrl+C</kbd> to stop `devspace dev`
1.  Run `$ devspace purge` to clean up resources

### Local development (Skaffold + Minikube)
1.  `$ asdf install`
1.  `$ minikube start`
1.  `$ skaffold dev --port-forward`
1.  Navigate to [fitness app](http://localhost:3000)
1.  Make code changes
1.  Refresh browser
1.  Repeat (change, refresh, etc)

#### Debugging
1.  In another terminal, run `$ kubectl attach -it fitness-web`
1.  Interact with debugger
1.  Detach by <kbd>Ctrl+P,Q</kbd>

#### Installing a Gem
1.  Get shell on pod via `$ kubectl exec -it fitness-web -- /bin/bash`
1.  Install gem via `$ bundle add <gem-name>`
1.  Exit out of shell via `$ exit`
1.  Copy changed files back to local repo via:
    1.  `$ kubectl cp fitness-web:/app/Gemfile ./Gemfile`
    1.  `$ kubectl cp fitness-web:/app/Gemfile.lock ./Gemfile.lock`

### Local development (Docker)
1.  `$ docker-compose up`
1.  Navigate to [fitness app](https://localhost:3000)
1.  Make code changes
1.  Refresh browser
1.  Repeat (change, refresh, etc)

#### Debugging
1.  Add `binding.pry` in code
1.  In another terminal, run `$ docker attach fitness-web`
1.  Interact with debugger
1.  Detach by <kbd>Ctrl+P,Q</kbd>

#### Installing a Gem
1.  Open a new terminal
1.  Get shell on web container via `$ docker-compose exec web bash`
1.  Install gem via `$ bundle add <gem-name>`

## Useful resources

- [Skaffold examples](https://github.com/GoogleContainerTools/skaffold/tree/master/examples)
- [RoR dev in devspace](https://devspace.cloud/blog/2019/10/21/deploy-ruby-on-rails-to-kubernetes)