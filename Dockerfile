# Etapa 1: Construcción y Pruebas
# Usamos una imagen ligera de Node
FROM node:18-alpine AS builder

WORKDIR /app

# Copiamos primero los archivos de dependencias (para aprovechar el caché de Docker)
COPY package*.json ./

# Instalamos las dependencias de forma limpia
RUN npm ci

# Copiamos todo el código fuente del repo
COPY . .

# 1. Ejecutamos el Linter (Calidad)
RUN npm run lint

# 2. Ejecutamos las Pruebas Unitarias (REQUISITO CRÍTICO DE LA EVALUACIÓN)
# Si esto falla, la creación de la imagen se detiene aquí.
RUN npm run test:unit

# 3. Construimos la aplicación (TypeScript -> JavaScript)
RUN npm run build

# Etapa 2: Imagen Final (Producción)
# Creamos una imagen nueva y limpia, sin el código fuente pesado, solo lo compilado.
FROM node:18-alpine

WORKDIR /app

# Copiamos solo lo necesario desde la etapa anterior ("builder")
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# Exponemos el puerto (ajustar si tu app usa otro)
EXPOSE 3000

# Comando de inicio
CMD ["node", "dist/index.js"]