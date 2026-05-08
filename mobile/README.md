# Latinoamérica Comparte CMS

Sistema de gestión de contenidos (CMS) para noticias, testimonios y solicitudes de contacto, desarrollado con:

* Backend: Node.js + Express + MongoDB Atlas
* Frontend: Flutter
* Autenticación: JWT
* Seguridad: bcrypt
* Gestión de archivos: Multer
* Control de roles: superadmin, admin_pais, editor

---

# Estado actual del proyecto

## Backend completado

* Conexión a MongoDB Atlas
* Configuración de Express
* Variables de entorno con `.env`
* Login con JWT
* Hash de contraseñas con bcrypt
* Usuario inicial `superadmin`
* Middleware de autenticación
* Middleware de roles
* CRUD de noticias
* Subida de imágenes con Multer
* Rutas protegidas

## Frontend iniciado

* Proyecto Flutter creado
* Dependencias iniciales instaladas
* Estructura base de carpetas
* Pantalla inicial de Login

---

# Estructura del proyecto

```text
latinoamerica-comparte/
│
├── backend/
│   ├── src/
│   │   ├── config/
│   │   ├── controllers/
│   │   ├── middlewares/
│   │   ├── models/
│   │   ├── routes/
│   │   └── app.js
│   │
│   ├── uploads/
│   ├── scripts/
│   ├── server.js
│   ├── package.json
│   └── .env
│
├── frontend/
│   ├── lib/
│   │   ├── screens/
│   │   ├── services/
│   │   ├── models/
│   │   ├── widgets/
│   │   └── main.dart
│   │
│   └── pubspec.yaml
│
└── README.md
```

---

# Requisitos previos

Instalar:

* Node.js
* npm
* Flutter SDK
* Android Studio o VS Code
* MongoDB Atlas
* Postman
* Git

---

# Instalación Backend

## 1. Clonar repositorio

```bash
git clone <url-del-repositorio>
cd latinoamerica-comparte
```

---

## 2. Entrar al backend

```bash
cd backend
```

---

## 3. Instalar dependencias

```bash
npm install
```

Dependencias principales:

```bash
npm install express mongoose cors dotenv bcrypt jsonwebtoken multer
npm install --save-dev nodemon
```

---

## 4. Crear archivo `.env`

```env
PORT=3000

MONGO_URI=tu_uri_de_mongodb

JWT_SECRET=latinoamericaComparteSecret
```

Ejemplo:

```env
MONGO_URI=mongodb://usuario:password@host.mongodb.net/latinoamericaComparte?retryWrites=true&w=majority
```

---

## 5. Ejecutar servidor

```bash
npm run dev
```

Resultado esperado:

```text
MongoDB conectado
Servidor corriendo en puerto 3000
```

---

# Usuario inicial (Super Admin)

## Crear usuario administrador

Script:

```bash
node scripts/createAdmin.js
```

Credenciales iniciales:

```text
correo: admin@test.com
password: 123456
rol: superadmin
```

---

# Endpoints actuales

## Auth

### Login

```http
POST /auth/login
```

Body:

```json
{
  "correo": "admin@test.com",
  "password": "123456"
}
```

---

## Ruta protegida

```http
GET /private
```

Header:

```text
Authorization: Bearer TOKEN
```

---

## Noticias

### Crear noticia

```http
POST /news
```

### Listar noticias

```http
GET /news
```

### Actualizar noticia

```http
PUT /news/:id
```

### Eliminar noticia

```http
DELETE /news/:id
```

---

# Instalación Frontend (Flutter)

## 1. Crear proyecto

```bash
flutter create frontend
cd frontend
```

---

## 2. Instalar dependencias

```bash
flutter pub add http
flutter pub add shared_preferences
flutter pub add provider
```

---

## 3. Ejecutar app

```bash
flutter run
```

---

# Próximas fases

## Fase 1

* Pantalla de Login real
* Pantalla de Países
* ADR técnico

## Fase 2

* Listado de noticias en Flutter
* Crear/editar noticia desde app

## Fase 3

* API y CRUD de testimonios

## Fase 4

* API y pantallas de solicitudes de contacto

## Fase 5

* Dashboard global
* Dashboard por país
* Filtros globales
* Integración final

---

# Roles del sistema

## superadmin

* Gestión global
* Gestión de países
* Gestión de usuarios
* Eliminar noticias
* Dashboard global

## admin_pais

* Gestión de noticias por país
* Gestión de usuarios de su país

## editor

* Crear y editar noticias
* Gestión básica de contenido

---

# Notas importantes

* Las contraseñas se almacenan con bcrypt
* Las rutas privadas usan JWT
* Las imágenes se almacenan en `/uploads`
* MongoDB Atlas requiere acceso de red habilitado
* Se recomienda usar conexión `mongodb://` si falla `mongodb+srv://`

---

# Autor

Proyecto académico - Latinoamérica Comparte CMS
