# database-proxy
A simple build for database proxy server 

### Build image
	git clone https://github.com/t7hm1/database-proxy.git && cd database-proxy
	docker image build -t db_proxy .
### Run 
* docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d db_proxy
* docker run --name some-postgres \
				-e POSTGRES_PASSWORD=mysecretpassword -d \
				-v /path/somewhere/:/var/lib/postgresql/data/ db_proxy
* docker run -tid --rm -p 5432 -e POSTGRES_USER=someuser db_proxy
### Params
	POSTGRES_DB POSTGRES_USER POSTGRES_PASSWORD
	
## License
![GitHub](https://img.shields.io/github/license/t7hm1/database-proxy)
