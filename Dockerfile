# ==========================================
# ETAPA 1: construcción (builder)
# ==========================================
FROM node:18-alpine AS builder

WORKDIR /app

# Copia solo los archivos del frontend
COPY index.html app.js ./

# ==========================================
# ETAPA 2: imagen final con nginx liviano
# ==========================================
FROM nginx:alpine

# Elimina contenido por defecto de nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia los archivos desde la etapa builder
COPY --from=builder /app/index.html /usr/share/nginx/html/
COPY --from=builder /app/app.js /usr/share/nginx/html/

# Copia configuración personalizada de nginx
COPY default.conf /etc/nginx/conf.d/default.conf

# Crea usuario sin privilegios root (seguridad)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Expone el puerto 80
EXPOSE 80