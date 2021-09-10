FROM jedrzejlewandowski/schemaver-check:1.2.0 AS schemaVerCheck

FROM node:14 AS builder
WORKDIR /app
ADD package* /app/
RUN npm ci
ADD schema.json babel.config.js package* tsconfig.json /app/
ADD src /app/src
RUN npm run build

FROM caddy:2-alpine
WORKDIR /srv
COPY --from=schemaVerCheck /bin/schemaver-check /bin/schemaver-check
COPY --from=builder /app/dist/* /srv/
ADD schema.json /srv/
ADD mocks /srv/mocks
ADD Caddyfile /etc/caddy/Caddyfile

ENV SCHEMAVERCHECK_SCHEMA_FILE=/srv/schema.json
CMD ["/bin/sh", "-c", "\
    schemaver-check --data-file /srv/mocks/company.json --definition-name \"CompanyStructure\" && \
    cat /etc/caddy/Caddyfile && \
    caddy run --config /etc/caddy/Caddyfile --adapter caddyfile \
    "]