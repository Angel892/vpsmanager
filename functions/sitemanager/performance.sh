#!/bin/bash

performance() {

    local nginxSitePath="/etc/nginx"

    showCabezera "Configurando performance"

    # agregar configuracion de performance
    cat <<EOF >$nginxSitePath/nginx.conf
user www-data;
worker_processes auto;
worker_rlimit_nofile 65535;
pid /run/nginx.pid;

# Optimize logging
error_log /var/log/nginx/error.log crit;

events {
    worker_connections 8192;  # Adjust based on your server's resources
    use epoll;  # Use epoll for better performance on Linux
    multi_accept on;  # Accept multiple connections at once
}

http {
    ##
    # Basic Settings
    ##

    access_log /var/log/nginx/access.log;  # Mover la directiva dentro del bloque http

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ##
    # Performance Optimization
    ##

    # Cache open file descriptors
    open_file_cache max=50000 inactive=60s;
    open_file_cache_valid 80s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;

    # Buffers for headers and bodies
    client_body_buffer_size 128k;
    client_max_body_size 10m;  # Adjust based on your application needs
    client_header_buffer_size 1k;
    large_client_header_buffers 4 32k;
    output_buffers 1 32k;
    postpone_output 1460;

    ##
    # Timeouts
    ##

    reset_timedout_connection on;
    client_body_timeout 12;
    client_header_timeout 12;
    send_timeout 10;

    ##
    # Security Settings
    ##

    # Hide Nginx version
    server_tokens off;

    # Prevent information disclosure
    server_name_in_redirect off;

    # Restrict access to methods
    if (\$request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
    }

    # Disable unwanted protocols
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384';

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'; frame-ancestors 'none'; base-uri 'self';" always;
    add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload" always;

    ##
    # Gzip Compression
    ##

    gzip on;
    gzip_disable "msie6";
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 4;  # Balance between CPU usage and compression
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    ##
    # Limit Requests and Connections
    ##

    limit_conn_zone \$binary_remote_addr zone=conn_limit_per_ip:10m;
    limit_conn conn_limit_per_ip 20;

    limit_req_zone \$binary_remote_addr zone=req_limit_per_ip:10m rate=10r/s;
    limit_req zone=req_limit_per_ip burst=15 nodelay;

    ##
    # SSL Settings
    ##

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_session_tickets off;

    ##
    # Include other configurations
    ##

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF

    sudo systemctl restart nginx

    msgSuccess
}
