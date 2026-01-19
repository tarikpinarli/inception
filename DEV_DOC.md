# Developer Documentation

This file serves as a comprehensive technical guide for developers. It details the system architecture, configuration variables, folder structure, and maintenance procedures.

## 1. Environment Setup

### System Prerequisites
Before running the project, ensure the host machine meets the following requirements:
* **OS:** Linux (Debian/Ubuntu recommended) or a VM running Linux.
* **Docker Engine:** Version 20.10.x or higher.
* **Docker Compose:** Version v2.x (accessed via `docker compose`).
* **Make:** GNU Make utility.

### Network Configuration (DNS Spoofing)
The project is configured to run on a specific domain (`tpinarli.42.fr`) rather than generic `localhost`. You must map this domain to your local loopback address.

1.  Open the hosts file:
    sudo nano /etc/hosts
2.  Add the following line at the top:
    127.0.0.1   tpinarli.42.fr

    *Why?* This allows the NGINX configuration to properly recognize the `server_name` and handle SSL certificate validation for that specific domain.

### Configuration & Credentials (`.env`)
The system relies on a `.env` file located at `./srcs/.env` to inject environment variables into the containers.

**Workflow:**
* **Source:** `./srcs/.env.sample` (Safe, template file committed to git).
* **Target:** `./srcs/.env` (Private, ignored by git).
* **Automation:** The `Makefile` automatically creates a copy of `.env.sample` as `.env` if the `.env` file does not exist.

**Required Variables Table:**
| Variable | Description |
| :--- | :--- |
| `DOMAIN_NAME` | The domain URL (e.g., tpinarli.42.fr) |
| `MYSQL_ROOT_PASSWORD` | Root password for MariaDB admin access |
| `MYSQL_DATABASE` | Name of the WordPress database to create |
| `MYSQL_USER` | Non-root SQL user for WordPress |
| `MYSQL_PASSWORD` | Password for the non-root SQL user |
| `WP_ADMIN_USER` | Username for the WordPress Dashboard Admin |
| `WP_ADMIN_PASSWORD` | Password for the WordPress Admin |
| `WP_ADMIN_EMAIL` | Email for the WordPress Admin |

## 2. Directory Structure

Understanding the file layout is crucial for troubleshooting build contexts and volume mapping.

### Source Code (`./`)
.
├── Makefile                  # Orchestration controller
├── srcs/
│   ├── docker-compose.yml    # Defines services, networks, and volumes
│   ├── .env.sample           # Template for environment variables
│   │
│   └── requirements/         # Microservices Definitions
│       ├── mariadb/
│       │   ├── Dockerfile    # OS & Package definition
│       │   ├── conf/         # Custom my.cnf configs
│       │   └── tools/        # Startup script (init db)
│       │
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   ├── conf/         # PHP-FPM pool config
│       │   └── tools/        # CLI install script
│       │
│       └── nginx/
│           ├── Dockerfile
│           ├── conf/         # SSL & Server block config
│           └── tools/        # Startup script