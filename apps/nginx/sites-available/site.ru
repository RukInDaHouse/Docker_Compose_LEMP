server {
  listen 80;
  listen [::]:80;

  root /var/www/html;
  server_name site.ru www.site.ru;
  index index.php;

  access_log /var/log/nginx/site-access.log;
  error_log /var/log/nginx/site-error.log;
  
    location ~ ^/\.user\.ini {
        deny all;
    }
    
    location ~ /\.(svn|git|hg) {
        deny all;
    }

    location ~*  \.(svg|svgz)$ {
        types {}
        default_type image/svg+xml;
    }

    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }
    
    location ~* ^.+\.(css|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|pdf|ppt|txt|tar|mid|midi|wav|bmp|rtf|js|swf)$ {
        root /var/www/DOMAIN_NAME/data;
        expires max;
        access_log   off;
    }
    
    location / {
        try_files $uri @apache;
    }

    location @apache {
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $host;
        
        client_max_body_size   	10m;
        client_body_buffer_size	1280k;
 
        proxy_connect_timeout  	90;
        proxy_send_timeout     	90;
        proxy_read_timeout     	90;
 
        proxy_buffer_size      	4k;
        proxy_buffers          	4 32k;
        proxy_busy_buffers_size	64k;
        proxy_temp_file_write_size 64k;
        
        proxy_pass http://wordpress;
    }

    location ~[^?]*/$ {
        client_max_body_size   	10m;
        client_body_buffer_size	1280k;
 
        proxy_connect_timeout  	90;
        proxy_send_timeout     	90;
        proxy_read_timeout     	90;
 
        proxy_buffer_size      	4k;
        proxy_buffers          	4 32k;
        proxy_busy_buffers_size	64k;
        proxy_temp_file_write_size 64k;
    
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $host;
        
        proxy_pass http://wordpress;
    }

    location ~ \.php$ {
        client_max_body_size   	10m;
        client_body_buffer_size	1280k;
 
        proxy_connect_timeout  	90;
        proxy_send_timeout     	90;
        proxy_read_timeout     	90;
 
        proxy_buffer_size      	4k;
        proxy_buffers          	4 32k;
        proxy_busy_buffers_size	64k;
        proxy_temp_file_write_size 64k;
    
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $host;
        
        proxy_pass http://wordpress;
    }
}
