todo
====

Playing around with a simple todo application.

Getting Started
---------------

You need bake to easily setup this application.

```
brew install bake
```

Run the default commands to initialize the application.

```
bake init
bake build
bake start
```

Development
-----------

Bake automates a lot of common development tasks. Some useful ones are:

```
bake ipython              # Runs ipython when developing on the service.
bake shell [db|service]   # Shells into running containers for debugging.
bake logs [db|service]    # Follow the logs for running containers.

bake create.migration     # Generate migration files to migrate databases.
bake clean                # Run this when you're done to cleanup your local artifacts.
```
