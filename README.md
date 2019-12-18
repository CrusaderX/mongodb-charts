In accordance with https://docs.mongodb.com/charts/master/launch-charts/#launch-charts this repo exist for whom who want to run this stuff locally with docker-compose.

```yaml

version: '2'

services:
  charts:
    build:
      context: 'docker/charts'
      args:
        - EMAIL=admin@example.com
        - PASSWORD=StrongPassw0rd
    image: charts
    ports:
      - 8080:80
    environment:
      CHARTS_SUPPORT_WIDGET_AND_METRICS: 'on'
      CHARTS_MONGODB_URI: 'mongodb://mongo:27017/admin?replicaSet=rs0'
    volumes:
      - keys:/mongodb-charts/volumes/keys
      - logs:/mongodb-charts/volumes/logs
      - db-certs:/mongodb-charts/volumes/db-certs
      - web-certs:/mongodb-charts/volumes/web-certs
    depends_on:
      - mongo
    container_name: charts

  mongo:
    hostname: mongo
    build:
      context: 'docker/mongo'
    ports:
      - 27017:27017
    volumes:
      - mongo:/data/db
    image: charts_mongo
    container_name: mongo

volumes:
  keys:
  logs:
  db-certs:
  web-certs:
  mongo:
```

Just one step to run

```console
$ docker-compose up -d
```

After ~2 mins you should be able to open your browser and navigate to http://localhost:8080 and see the login menu. Login and password are described in compose file.