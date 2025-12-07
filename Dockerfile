# Etapa 1: Construcción
FROM node:20-alpine3.20 AS builder
WORKDIR /app

# Copiamos archivos de dependencias
COPY package*.json ./

# Instalamos TODAS las dependencias (incluidas dev para tests)
RUN npm ci --ignore-scripts && \
    npm cache clean --force

# Copiamos TODO el código (incluyendo jest.setup.js)
COPY . .

# Ejecutamos linter
RUN npm run lint

# Ejecutamos pruebas unitarias
RUN npm run test:unit -- --no-cache --runInBand

# Construimos la aplicación
RUN npm run build

# Etapa 2: Imagen Final (Producción)
FROM node:20-alpine3.20
WORKDIR /app

# Instalar actualizaciones de seguridad
RUN apk upgrade --no-cache

# Crear usuario no-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copiar solo lo necesario para producción
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/package*.json ./

# Instalar solo dependencias de producción
RUN npm ci --only=production --ignore-scripts && \
    npm cache clean --force

USER nodejs
EXPOSE 3000

CMD ["node", "dist/index.js"]