server {
  listen 80;
  server_name ${vm_domain};
  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl;
  server_name ${vm_domain};

  ssl_certificate /etc/ssl/ssl_certificate.crt;
  ssl_certificate_key /etc/ssl/ssl_certificate.key;
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384';
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:10m;
  ssl_session_timeout 1d;
  ssl_session_tickets off;

  location / {
    proxy_pass http://${wordpress_app_service_url};
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}