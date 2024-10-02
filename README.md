# docker-demp

## Settings

```
cp .env.example .env
cp docker-compose.yml.example docker-compose.yml
docker compose up -d --build
```

## Useful commands line

```
# Copy configuration from docker image to host machine
docker run -it --name test1 --rm php:7.3.33-fpm-alpine3.15
docker cp test1:/usr/local/etc/php php7.3_copy

docker run -it --name test2 --rm docker.io/nginx:1.27.0-alpine3.19-slim
docker cp test2:/etc/nginx nginx_copy

# Build image
docker build -t phamphu232/php:7.3.33-fpm-alpine3.15 -f ./php.Dockerfile .
docker push phamphu232/php:7.3.33-fpm-alpine3.15
```

## Config logrotate

```
# Create file: /etc/logrotate.d/nginx
/home/ubuntu/docker-lemp/log/nginx/*.log {
    dateext
    daily
    rotate 31
    nocreate
    missingok
    notifempty
    nocompress
    postrotate
        /usr/bin/docker exec nginx /bin/sh -c '/usr/sbin/nginx -s reopen > /dev/null 2>/dev/null'
    endscript
}
```

- Logrotate uses crontab to work. It's scheduled work, not a daemon, so no need to reload its configuration.
- When the crontab executes logrotate, it will use your new config file automatically.
- If you need to test your config you can also execute logrotate on your own with the command:

    ```
    ## Syntax:
    # logrotate /etc/logrotate.d/your-logrotate-config

    ## Example:
    logrotate /etc/logrotate.d/nginx
    ```

- If you want to have a debug output use argument -d

    ```
    ## Syntax:
    # logrotate -v /etc/logrotate.d/your-logrotate-config

     ## Example:
    logrotate -v /etc/logrotate.d/nginx
    ```

## Create self certificates

```
openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -keyout self-signed.key -out self-signed.crt
```

## configuration php with nginx
Fifle \nginx\conf.d\default.conf
Enable :
    location ~ \.php$ {
        root           /var/www;
        fastcgi_index  index.php;
        include        fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
    }
