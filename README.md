# Project Time Management System (PTMS)

A web-based **Project Time Management and Employee Work Tracking System** built with **PHP 8**, **MySQL 8**, and **AdminLTE**. The application allows organizations to track employee working hours across different projects, generate productivity reports, and manage administrative settings with role-based access control.

---

## 🚀 Live Deployment Details

- **Hosting Platform:** [Render](https://render.com) (Docker Web Service)
- **Database:** [Aiven](https://aiven.io) (Managed MySQL 8.0 with SSL)
- **Runtime:** PHP 8.1 with Apache & MySQLi

### URLs:
- **Employee Portal:** `https://<your-render-url>/`
- **Admin Dashboard:** `https://<your-render-url>/admin`

---

## 🔑 Default Login Credentials

### 1. Admin Panel
- **URL:** `/admin`
- **Username:** `admin`
- **Password:** `admin123`
- **Capabilities:**
  - Create, manage, and close projects
  - Manage employee directory and credentials
  - Configure work types and task categories
  - View organization-wide time logs and productivity reports
  - Update system branding, logo, and cover photo

### 2. Employee / User Portal
- **URL:** `/` (or `/login.php`)
- **Sample Account 1:**
  - **Email:** `mcooper@sample.com`
  - **Password:** `mcooper123`
- **Sample Account 2:**
  - **Email:** `jsmith@sample.com`
  - **Password:** `jsmith123`
- **Sample Account 3:**
  - **Email:** `cblake@sample.com`
  - **Password:** `cblake123`
- **Capabilities:**
  - Daily time tracking and timesheet submission
  - Log hours spent per project and work category
  - Review personal performance logs and historical submissions

---

## 🛠️ Tech Stack

- **Backend:** PHP 8.1, Apache, MySQLi (with SSL support)
- **Frontend:** Bootstrap 4, AdminLTE Theme, jQuery, Chart.js
- **Database:** MySQL 8.0 / MariaDB
- **Containerization:** Docker (`php:8.1-apache` base image)
- **Cloud Infrastructure:** Render Web Services, Aiven Cloud Database

---

## ⚙️ Environment Variables

When deploying to Render, Railway, or VPS, the application dynamically reads database credentials from environment variables:

| Variable | Description | Default / Example |
|---|---|---|
| `DB_HOST` / `DB_SERVER` | MySQL Host | `127.0.0.1` or `mysql-xxxx.aivencloud.com` |
| `DB_PORT` | MySQL Port | `3306` or `24024` |
| `DB_USER` / `DB_USERNAME` | MySQL User | `ptms_user` or `avnadmin` |
| `DB_PASSWORD` | MySQL Password | `<your_db_password>` |
| `DB_NAME` | Database Name | `defaultdb` or `ptms_db` |
| `BASE_URL` | Base Application URL *(Optional)* | Auto-detected from Host header |
| `DATABASE_URL` | Full MySQL URI *(Optional alternative)* | `mysql://user:pass@host:port/dbname` |

---

## 📦 How to Deploy on Render

1. **Fork or Push this repository to GitHub.**
2. Login to [Render Dashboard](https://dashboard.render.com).
3. Click **New +** > **Web Service** > **Build and deploy from a Git repository**.
4. Select this repository: `TimeMangementSystem`.
5. Configuration:
   - **Environment / Runtime:** `Docker`
   - **Branch:** `main`
   - **Plan:** `Free`
6. Under **Environment Variables**, add your Aiven MySQL credentials:
   - `DB_HOST`: `<aiven-host>`
   - `DB_PORT`: `24024`
   - `DB_USER`: `avnadmin`
   - `DB_PASSWORD`: `<aiven-password>`
   - `DB_NAME`: `defaultdb`
7. Click **Deploy Web Service**.
8. The database schema with primary keys and default data will automatically initialize upon first access.

---

## 💻 Local Setup (XAMPP)

1. Download and install [XAMPP](https://www.apachefriends.org/).
2. Start **Apache** and **MySQL** from XAMPP Control Panel.
3. Clone or copy the `ptms` directory into `C:\xampp\htdocs\ptms`.
4. Open phpMyAdmin (`http://localhost/phpmyadmin`).
5. Create a new database named `ptms_db`.
6. Import `ptms/database/ptms_db.sql` into `ptms_db`.
7. Access the application in your browser:
   - User Portal: `http://localhost/ptms/`
   - Admin Panel: `http://localhost/ptms/admin/`

---

## 🐳 Local Setup (Docker)

To run the full stack containerized on your local machine:

```bash
# Build the Docker image
docker build -t time-management-system .

# Run the container (maps container port to local 8080)
docker run -p 8080:80 time-management-system
```

Open `http://localhost:8080/` in your browser. The container includes built-in MariaDB and auto-imports the database schema on first run.

---

## 📁 Project Structure

```
TimeMangementSystem/
├── Dockerfile                   # Docker container definition (PHP 8.1 + Apache + MariaDB)
├── docker-entrypoint.sh         # Dynamic port binding & MariaDB setup script
├── render.yaml                  # Render Blueprint definition
├── import_to_aiven.js           # CLI script to import schema to Aiven cloud DB
├── README.md                    # Project documentation & credentials
└── ptms/                        # Main Application Source Code
    ├── admin/                   # Admin panel modules, views, and controllers
    ├── classes/                 # Core backend classes (DBConnection, SystemSettings, Login, Users)
    ├── database/
    │   └── ptms_db.sql          # Modernized MySQL 8 compliant schema with seed data
    ├── dist/                    # AdminLTE styles, CSS, and images
    ├── inc/                     # Reusable layout components (header, footer, navbar)
    ├── plugins/                 # Frontend libraries (Bootstrap, jQuery, Select2, Chart.js)
    ├── uploads/                 # Media uploads (logos, avatars, covers)
    ├── config.php               # Application initialization & helper functions
    ├── initialize.php           # Dynamic environment variables & DB config loader
    ├── index.php                # Employee dashboard routing entry point
    ├── login.php                # Employee login view
    └── register.php             # Employee self-registration view
```

---

## 🔒 Security Notes

- Passwords are encrypted using MD5 hashing in the database.
- Database connections to cloud databases (like Aiven) are automatically secured with SSL (`MYSQLI_CLIENT_SSL_DONT_VERIFY_SERVER_CERT`).
- Reverse-proxy HTTPS headers (`X-Forwarded-Proto`) are respected for SSL redirects and assets.
