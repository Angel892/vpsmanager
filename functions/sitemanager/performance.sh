#!/bin/bash

performance() {

    local nginxSitePath="/etc/nginx"

    showCabezera "Configurando performance"

    # agregar configuracion de performance
    cat <<EOF >$nginxSitePath/nginx.conf
# you must set worker processes based on your CPU cores, nginx does not benefit from setting more than that
worker_processes auto; #some last versions calculate it automatically

# number of file descriptors used for nginx
# the limit for the maximum FDs on the server is usually set by the OS.
# if you don't set FD's then OS settings will be used which is by default 2000
worker_rlimit_nofile 100000;

# only log critical errors
error_log /var/log/nginx/error.log crit;

# provides the configuration file context in which the directives that affect connection processing are specified.
events {
    # determines how much clients will be served per worker
    # max clients = worker_connections * worker_processes
    # max clients is also limited by the number of socket connections available on the system (~64k)
    worker_connections 4000;

    # optimized to serve many clients with each thread, essential for linux -- for testing environment
    use epoll;

    # accept as many connections as possible, may flood worker connections if set too low -- for testing environment
    multi_accept on;
}

http {
    # cache informations about FDs, frequently accessed files
    # can boost performance, but you need to test those values
    open_file_cache max=200000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;

    # to boost I/O on HDD we can disable access logs
    access_log off;

    # copies data between one FD and other from within the kernel
    # faster than read() + write()
    sendfile on;

    # send headers in one piece, it is better than sending them one by one
    tcp_nopush on;

    # don't buffer data sent, good for small data bursts in real time
    tcp_nodelay on;

    # reduce the data that needs to be sent over network -- for testing environment
    gzip on;
    # gzip_static on;
    gzip_min_length 10240;
    gzip_comp_level 1;
    gzip_vary on;
    gzip_disable msie6;
    gzip_proxied expired no-cache no-store private auth;
    gzip_types
        # text/html is always compressed by HttpGzipModule
        text/css
        text/javascript
        text/xml
        text/plain
        text/x-component
        application/javascript
        application/x-javascript
        application/json
        application/xml
        application/rss+xml
        application/atom+xml
        font/truetype
        font/opentype
        application/vnd.ms-fontobject
        image/svg+xml;

    # allow the server to close connection on non responding client, this will free up memory
    reset_timedout_connection on;

    # request timed out -- default 60
    client_body_timeout 10;

    # if client stop responding, free up memory -- default 60
    send_timeout 2;

    # server will close connection after this time -- default 75
    keepalive_timeout 30;

    # number of requests client can make over keep-alive -- for testing environment
    keepalive_requests 100000;
}
EOF

    sudo systemctl restart nginx

    msgSuccess
}
