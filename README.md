Bits Inventions - The API for Inventions Database

The application allows to Create, Update, Destroy And Find Invention records. The user can find an Invention by id, title or names ot bits that are used for this Invention. The user can delete or update Invention record finding it by `title` or by `id`

## Local Environment Setup

### Local software prerequisites
- Git
- Ruby 2.5.1
- Rails 5.2.1
- PostgreSQL 9.4.4
### Install all gems
```
bundle install
```

### Setup DB
```
rake db:create
```

### Run migrations
```
rake db:migrate
```

### Run tests
```
rspec
```

### Run the application
```
rails s
```

### See available routes
```
rake routes
```

### Check progress
```
git log
```

Use Postman app or similar to make test requests. Read test suite to learn all potential functionality.
The application requires to receive JWT token in Authorization headers. There is no user functionality that dynamically generates token, so it has to be pregenerated manually.