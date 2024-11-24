#!/bin/sh
if hash docker-compose 2>/dev/null; then
	docker-compose exec --user devilbox php zsh -l
else
	docker compose exec --user devilbox php zsh -l
fi
