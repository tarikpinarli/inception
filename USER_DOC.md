# User Documentation

This guide explains how to use the services provided by the Inception.

## 1. Services Provided
When the project is running, the following services are active:
* **Website:** A full WordPress CMS accessible via your web browser.
* **Database:** A MariaDB database that stores your site's content (users, posts, comments).
* **Web Server:** NGINX, which serves the content securely over HTTPS.

## 2. Starting and Stopping
All controls are managed via the terminal in the root directory.

* **Start:** `make up`
    * *Note:* The first startup may take about 12 minutes, as it builds the Docker images and downloads WordPress.
* **Stop:** `make down`

## 3. Accessing the Website
1.  Ensure the project is running (`docker ps` should show 3 active containers).
2.  Open your web browser.
3.  Navigate to: **https://tpinarli.42.fr**
    * *Security Warning:* Since we use a self-signed SSL certificate, your browser will warn you that the connection is not private. You must click "Advanced" -> "Proceed to tpinarli.42.fr (unsafe)" to view the site.

## 4. Credentials
The project credentials (passwords and usernames) are stored in a `.env` file. This file is automatically created from a template called `.env.sample` when you start the project.

**How to set your own secure credentials:**
If you want to use your own secure passwords instead of the defaults, simply edit the `./srcs/.env.sample` file **before** starting the project.
* If the project is already running, edit the file and then run `make re` to rebuild the containers with your new passwords.

**Key Variables:**
* **WordPress Admin:** `WP_ADMIN_USER` / `WP_ADMIN_PASSWORD`
* **Database User:** `MYSQL_USER` / `MYSQL_PASSWORD`

## 5. Verification
To check if the services are running correctly:
1.  Run `docker ps` in your terminal. You should see three containers listed: `nginx`, `wordpress`, and `mariadb`.
2.  If something isn't working, you can check the logs using: `docker logs nginx` or `docker logs wordpress`.