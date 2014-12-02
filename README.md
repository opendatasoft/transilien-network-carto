# Transilien network

Carto style for rendering Transilien network.

## Install

### Overview

Dependencies: postgres, postgis, osm2pgsql, mapnik 3.x, carto

Steps:

1. install dependencies
2. create a postgis aware database
3. download OSM data
4. import osm data to db with osm2pgsql
5. render map


### Ubuntu 14.04 step by step

1. Install dependencies

    ```
    sudo apt install postgresql-client-9.4 postgresql-9.4-postgis-2.1 osm2pgsql
    ```

    We need Mapnik 3.x version (because we use `text-repeat-wrap-character`). For
    this, follow the instructions in the [mapnik wiki](https://github.com/mapnik/mapnik/wiki/UbuntuInstallation#install-from-packages).

    We need an up to date NodeJS: for this, follow the instructions in the
    [NodeJS wiki](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#debian-and-ubuntu-based-linux-distributions).

    To read the project, we'll use [Kosmtik](https://github.com/kosmtik/kosmtik)
    as carto wrapper. Install instructions are available on the [Github README](https://github.com/kosmtik/kosmtik#install).

    We will also need some Kosmtik plugins, so once in the kosmtik root, run:

    ```
    node index.js plugins --install kosmtik-tiles-export
    node index.js plugins --install kosmtik-mbtiles-export
    node index.js plugins --install kosmtik-fetch-remote
    ```

    We need to override some of the project configs to match our working
    environment, for example for the database credentials. For this, create a 
    `localconfig.js` file in the root of the map project, with this content (adapt
    it to your needs):

    ```javascript
    exports.LocalConfig = function (localizer, project) {
        localizer.where('Layer').if({'Datasource.type': 'postgis'}).then({
            'Datasource.dbname': 'idf',
            'Datasource.password': '',
            'Datasource.user': 'ybon',
            'Datasource.host': ''
        });
    };
    ```
    See [Kosmtik local configuration](https://github.com/kosmtik/kosmtik#local-config)
    for more details if needed.


2. Create a PostGIS aware DB

If you don't have a user yet, create one:
```
sudo -u postgres createuser {youruser}
```

Then create the db:
```
sudo -u postgres createdb transilien -O {youruser}
```

Activate postgis and hstore extensions:
```
sudo -u postgres psql transilien
transilien=# CREATE EXTENSION postgis;
transilien=# CREATE EXTENSION hstore;
```

3. Download OSM data

We need `.osm.pbf` files from Geofabrik:

- [Ile-de-France](http://download.geofabrik.de/europe/france/ile-de-france-latest.osm.pbf)
- [Picardie](http://download.geofabrik.de/europe/france/picardie.osm.pbf)
- [Centre](http://download.geofabrik.de/europe/france/centre.osm.pbf)
- [Haute-Normandie](http://download.geofabrik.de/europe/france/haute-normandie.osm.pbf)
- [Champagne-Ardenne](http://download.geofabrik.de/europe/france/champagne-ardenne.osm.pbf)
- [Bourgogne](http://download.geofabrik.de/europe/france/bourgogne.osm.pbf)

We could also download and import the whole France file, but it would be longer.


4. Import data

First, import Île-de-France, in *create* mode:
```
osm2pgsql -G -U {youruser} -d transilien path/to/ile-de-france-latest.osm.pbf --hstore --create
```

Then, import all other files in *append* mode, for example:
```
osm2pgsql -G -U {youruser} -d transilien path/to/picardie-latest.osm.pbf --hstore --append
```

5. Render map locally

From the root of your kosmtik instance, run:

```
node index.js serve path/to/transilien/project.yml
```

Then browse to http://localhost:6789


6. Export map

Export a tiles tree:

```
node index.js export path/to/transilien/project.yml --format tiles --output path/to/output/ --minZoom 10 --maxZoom 14
```

Export a MBTiles file:

```
node index.js export path/to/transilien/project.yml --format mbtiles --output path/to/output.mbtiles --minZoom 10 --maxZoom 14
```
