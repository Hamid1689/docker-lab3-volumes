docker volume create postgres-lab-data
docker run -d --name postgres-lab --mount source=postgres-lab-data,target=/var/lib/postgresql/data -e POSTGRES_USER=student -e POSTGRES_PASSWORD=student123 -e POSTGRES_DB=university -p 5432:5432 postgres:15-alpine
docker ps
docker logs postgres-lab

docker exec -i postgres-lab psql -U student -d university < init.sql
docker exec -it postgres-lab psql -U student -d university

docker stop postgres-lab
docker rm postgres-lab
docker volume ls
docker volume inspect postgres-lab-data
docker run -d --name postgres-lab-2 --mount source=postgres-lab-data,target=/var/lib/postgresql/data -e POSTGRES_USER=student -e POSTGRES_PASSWORD=student123 -p 5432:5432 postgres:15-alpine
docker exec -it postgres-lab-2 psql -U student -d university -c "SELECT * FROM students;"

docker exec postgres-lab-2 pg_dump -U student university > backup.sql
docker run --rm --mount source=postgres-lab-data,target=/data -v "%cd%":/backup ubuntu tar czf /backup/postgres-volume-backup.tar.gz /data