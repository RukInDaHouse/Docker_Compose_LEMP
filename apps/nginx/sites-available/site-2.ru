server {
  listen 80;
  listen [::]:80;

  root /var/www/html;
  server_name site-2.ru www.site-2.ru;
  index index.php;

  access_log /var/www/site-2.ru/log/nginx/site-access.log;
  error_log /var/www/site-2.ru/log/nginx/site-access.log;
  
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
    
    location ~* ^/phpmyadmin {
	return 301 $scheme://site-2.ru:8081;
    }
    
    location ~* ^.+\.(css|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|pdf|ppt|txt|tar|mid|midi|wav|bmp|rtf|js|swf)$ {
        root /var/www/site-2.ru;
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
        
        proxy_pass http://apache;
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
        
        proxy_pass http://apache;
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
        
        proxy_pass http://apache;
    }
}
