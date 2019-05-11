server {
    listen      %ip%:%web_port%;
    server_name %domain% %alias%;
    root        /var/lib/roundcube;
    index       index.php index.html index.htm;
    access_log /var/log/nginx/domains/%domain%.log combined;
    error_log /var/log/nginx/domains/%domain%.error.log error;

    include %home%/%user%/conf/mail/%root_domain%/nginx.forcessl.conf*;
  
    location ~ /\.(?!well-known\/) {
        deny all;
        return 404;
    }
	
    location ~ ^/(README.md|config|temp|logs|bin|SQL|INSTALL|LICENSE|CHANGELOG|UPGRADING)$ {
        deny all;
        return 404;
    }
    
    location / {
       try_files $uri $uri/ /index.php?q=$uri&$args;
       location ~* ^.+\.(ogg|ogv|svg|svgz|swf|eot|otf|woff|mov|mp3|mp4|webm|flv|ttf|rss|atom|jpg|jpeg|gif|png|ico|bmp|mid|midi|wav|rtf|css|js|jar)$ {
            expires 7d;
            fastcgi_hide_header "Set-Cookie";
        }
    }

    location ~ ^/(.*\.php)$ {
        alias /var/lib/roundcube/$1;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $request_filename;
    }
    
    error_page 403 /error/404.html;
    error_page 404 /error/404.html;
    error_page 500 502 503 504 505 /error/50x.html;

    location /error/ {
        alias /var/www/document_errors/;
    }

    include %home%/%user%/conf/mail/%root_domain%/%web_system%.conf_*;
}
