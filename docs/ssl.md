[Strong SSL Security on Nginx](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html)

# Nginx SSL settings (Let's encrypt)

```
ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
ssl_prefer_server_ciphers on;
ssl_session_cache shared:SSL:10m;

ssl_certificate /etc/letsencrypt/live/{key-name}/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/{key-name}/privkey.pem;
```

# Use stronger DHE parameter

Generate the parameter (this takes several minutes):

```
cd /etc/ssl/certs
openssl dhparam -out dhparam.pem 4096
```

Add to nginx:

```
ssl_dhparam /etc/ssl/certs/dhparam.pem;
```

# Analyze SSL security

```
https://www.ssllabs.com/ssltest/analyze.html?d={domain}
```
