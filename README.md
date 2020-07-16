# Postgresql on docker
![license](https://img.shields.io/github/license/mach1el/database-proxy?color=magenta&style=plastic)
![reposize](https://img.shields.io/github/repo-size/mach1el/docker-postgresql?style=plastic)
![imgsize](https://img.shields.io/docker/image-size/mich43l/postgresql/latest?color=orange&style=plastic)
![dockerautomated](https://img.shields.io/docker/automated/mich43l/postgresql?style=plastic)

A simple build for database proxy server using postgresql.

### Build image from source
  git clone https://github.com/mach1el/docker-postgresql.git && cd docker-postgresql
  docker image build -t database-server .

### Run 
* docker run --name some-postgres -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword -d database-server
* docker run -tid --rm -p 5432 -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_USER=someuser database-server
* docker run --name some-postgres \
    -e POSTGRES_PASSWORD=mysecretpassword -d \
    -v /path/somewhere/:/var/lib/postgresql/data/ database-server

### Params
|     Param     |     Exaplain     |
|:-------------:|:----------------:| 
|  POSTGRES_DB  | Specify name for database |
| POSTGRES_USER | Specify other name instead of postgres |
| POSTGRES_PASSWORD | This param must specify to run |