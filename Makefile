.PHONY: help init build up down test migrate superuser lint clean

help:
	@echo "Available commands:"
	@echo "  init       - Initialize the project (create Django project)"
	@echo "  build      - Build docker containers"
	@echo "  up         - Start containers"
	@echo "  down       - Stop containers"
	@echo "  test       - Run tests"
	@echo "  migrate    - Run migrations"
	@echo "  superuser  - Create superuser"
	@echo "  lint       - Run code linting"
	@echo "  clean      - Clean up temporary files"

init:
	@echo "Creating Django project..."
	docker-compose -f docker/docker-compose.yml run --rm web django-admin startproject ecommerce .
	@echo "Project initialized. You may need to adjust settings."

build:
	docker-compose -f docker/docker-compose.yml build

up:
	docker-compose -f docker/docker-compose.yml up -d

down:
	docker-compose -f docker/docker-compose.yml down

test:
	docker-compose -f docker/docker-compose.yml run --rm web pytest -xvs

migrate:
	docker-compose -f docker/docker-compose.yml run --rm web python manage.py migrate

superuser:
	docker-compose -f docker/docker-compose.yml run --rm web python manage.py createsuperuser

lint:
	docker-compose -f docker/docker-compose.yml run --rm web flake8 .

clean:
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type d -name ".pytest_cache" -exec rm -r {} +
	rm -f .coverage