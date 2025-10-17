
all: run

run:
	cd srcs && docker-compose up --build -d

stop:
	cd srcs && docker-compose down

clean:
	cd srcs && docker-compose down --rmi all --volumes --remove-orphans
	docker system prune -f
	docker volume prune -f
	docker network prune -f
	docker image prune -f
	docker container prune -f

re: clean all