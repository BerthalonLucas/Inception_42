all: build

build:
	@mkdir -p /home/lberthal/data/wordpress
	@mkdir -p /home/lberthal/data/mariadb
	@sudo chown -R $(USER):$(USER) /home/lberthal/data
	@sudo chmod -R 755 /home/lberthal/data
	cd srcs && docker compose up --build -d

reload:
	cd srcs && docker compose down && docker compose up --build -d

stop:
	cd srcs && docker compose down

clean:
	cd srcs && docker compose down --rmi all --volumes --remove-orphans
	docker system prune -f
	docker volume prune -f
	docker network prune -f
	docker image prune -f
	docker container prune -f
	@sudo rm -rf /home/lberthal/data/wordpress/*
	@sudo rm -rf /home/lberthal/data/mariadb/*

fclean: clean
	@sudo rm -rf /home/lberthal/data

re: fclean all