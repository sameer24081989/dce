FROM node:24-bookworm-slim
WORKDIR /app
COPY --chown=node:node package.json /app/package.json
COPY --chown=node:node worker /app/worker
COPY --chown=node:node sdc /app/sdc
RUN mkdir -p /var/lib/dce && chown node:node /var/lib/dce
USER node
EXPOSE 8080
ENV HOST=0.0.0.0 PORT=8080 SDC_DATABASE=/var/lib/dce/register.sqlite
CMD ["node", "sdc/server.mjs"]
