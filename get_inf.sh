#!/bin/bash

echo "=========================================="
echo "INCEPTION PROJECT OVERVIEW"
echo "=========================================="
echo ""

echo "📁 STRUCTURE DU PROJET"
echo "=========================================="
tree -L 4 -a
echo ""

echo "=========================================="
echo "📄 CONTENU DES FICHIERS"
echo "=========================================="
echo ""

# Fonction pour afficher un fichier
show_file() {
    if [ -f "$1" ]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "📄 $1"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        cat "$1"
        echo ""
        echo ""
    fi
}

# Makefile
show_file "Makefile"

# Docker Compose
show_file "srcs/compose.yml"

# .env si il existe
show_file "srcs/.env"

# NGINX
show_file "srcs/requirements/nginx/Dockerfile"
show_file "srcs/requirements/nginx/conf/nginx.conf"
show_file "srcs/requirements/nginx/tools/entrypoint.sh"

# MariaDB
show_file "srcs/requirements/mariadb/Dockerfile"
find srcs/requirements/mariadb/conf -type f 2>/dev/null | while read f; do show_file "$f"; done
find srcs/requirements/mariadb/tools -type f 2>/dev/null | while read f; do show_file "$f"; done

# WordPress
show_file "srcs/requirements/wordpress/Dockerfile"
find srcs/requirements/wordpress/conf -type f 2>/dev/null | while read f; do show_file "$f"; done
find srcs/requirements/wordpress/tools -type f 2>/dev/null | while read f; do show_file "$f"; done

echo "=========================================="
echo "✅ FIN DU RAPPORT"
echo "=========================================="