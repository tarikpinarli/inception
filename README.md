# Inception

This project has been created as part of the 42 curriculum by tpinarli.

## 1. Description
This project is a System Administration exercise designed to simulate a small-scale infrastructure setup using **Docker**. The goal is to build a LEMP stack (Linux, NGINX, MariaDB, PHP-FPM) and WordPress, running in separate, isolated containers orchestrated by `docker-compose`.

Instead of using pre-made images, this project requires building custom Docker images based on `debian:bullseye` for each service, configuring them manually, and ensuring they communicate via a dedicated Docker network.

## 2. Instructions

### Prerequisites
- Docker Engine & Docker Compose
- `make` utility
- `sudo` privileges (required to set permissions for data directories)

### Execution
The project is controlled via a `Makefile` at the root of the repository.

1.  **Start the Project:**
    Builds the images, creates the necessary volume directories, and starts the containers in the background.
    make up

2.  **Stop the Project:**
    Stops the containers without removing the data volumes.
    make down

3.  **Clean (Reset):**
    Stops the containers and removes the Docker networks and volumes (Data is preserved).
    make clean

4.  **Full Clean (Deep Reset):**
    This deletes all persistent data (database and website files) and removes all Docker images.
    make fclean

## 3. Project Description & Design Choices

### Architecture
The project utilizes a multi-container architecture:
1.  **NGINX:** The entry point. It handles SSL/TLS (port 443) and forwards PHP requests to the WordPress container.
2.  **WordPress (PHP-FPM):** This container runs the PHP runtime and WordPress source code. It acts as the bridge between the web server and the database.
3.  **MariaDB:** The database backend. It runs in a secured container, accessible only by WordPress, not the outside world.

### Technical Comparisons

#### Virtual Machines vs Docker
* **Virtual Machines (VMs):** VMs simulate an entire computer, including hardware (CPU, RAM) and a full Operating System. This makes them heavy, slower to boot, and resource-intensive.
* **Docker (Containers):** Containers are lightweight because they use the host's existing Linux kernel instead of booting a new OS. They isolate applications while using far fewer system resources and starting up almost instantly.

#### Secrets vs Environment Variables
* **Environment Variables:** To prevent leaking real credentials, I do not push the actual `.env` file to the repository. Instead, I provide a `.env.sample` file. The Makefile automatically creates a functional `.env` from this sample if one is missing. This prevents accidental leaks of sensitive data while still ensuring a flawless, "out-of-the-box" experience for the user trying the project.

#### Docker Network vs Host Network
* **Host Network:** The container shares the host machine’s IP address and network directly. While fast, it offers no isolation, meaning port conflicts are common (e.g., two services can't both use port 80).
* **Docker Network (Bridge):** The default for this project. It creates an isolated internal network. Containers get their own internal IP addresses and communicate using their names (DNS), keeping them secure and organized without exposing internal ports to the outside world.

#### Docker Volumes vs Bind Mounts
* **Docker Volumes:** Storage managed entirely by Docker in a specific, internal location. They are safer and easier to back up but harder to access directly from the host file system.
* **Bind Mounts:** These map a specific folder on your computer directly to a folder inside the container.
    * *My Choice:* This project uses **Bind Mounts** (`/home/tpinarli/data`) to meet the subject requirement. It allows us to easily verify that data is persisting by simply looking at the folders on the host machine.

## 4. Resources
### References
- [Docker Documentation](https://docs.docker.com/)
- [NGINX Beginner's Guide](https://nginx.org/en/docs/beginners_guide.html)
- [WP-CLI Documentation](https://make.wordpress.org/cli/handbook/)

### AI Usage
AI tools were used in this project primarily for educational purposes and as a learning assistant:
- **VM Setup:** Provided extensive guidance on building the Virtual Machine environment, specifically for implementing the Graphical User Interface (GUI) to create a comfortable development workspace.
- **Concept Understanding:** Used to ask general questions about Docker architecture and how different services (like NGINX and PHP) interact with each other.
- **Troubleshooting:** Used to help understand the meaning of standard error logs when services failed to start, which helped in finding the correct solution faster.
- **Documentation:** Used to review the project documentation to ensure the English was clear, grammatically correct, and easy to read.