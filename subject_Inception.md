# Inception

_Summary:_ This document is a System Administration related exercise.  
_Version:_ **4.0**

> **Note**  
> This Markdown is a faithful transcription of the official subject for the **Inception** project, with the **AI Instructions** chapter intentionally **omitted** per your request.

---

## Contents

- [I. Preamble](#i-preamble)
- [II. Introduction](#ii-introduction)
- [III. General guidelines](#iii-general-guidelines)
- [V. Mandatory part](#v-mandatory-part)
- [VI. Bonus part](#vi-bonus-part)
- [VII. Submission and peer-evaluation](#vii-submission-and-peer-evaluation)

---

## I. Preamble

> _Image reference (original page 3):_ meme showing Leonardo DiCaprio with the captions  
> **“ONE CONTAINER IS NOT ENOUGH”** / **“WE NEED TO GO DEEPER”**.

---

## II. Introduction

This project aims to broaden your knowledge of **system administration** through the use of **Docker** technology. You will virtualize several Docker images by **creating them yourself** in your new personal **virtual machine**.

---

## III. General guidelines

- This project **must be completed on a Virtual Machine**.  
- All the files required for the configuration of your project must be placed in a `srcs/` folder.  
- A **Makefile** is required at the **root** of your repository. It **must set up your entire application** (i.e., it has to **build the Docker images** using `docker-compose.yml`).  
- This subject may require concepts you haven’t fully learned yet. You are expected to **read documentation extensively** (Docker usage and any other helpful resources).

---

## V. Mandatory part

This project involves setting up a small infrastructure composed of different services under specific rules. The whole project must be done **inside a virtual machine**. You **must use Docker Compose**.

### Global constraints

- **Each Docker image must have the same name as its corresponding service.**  
- **Each service** must run in a **dedicated container**.  
- For performance reasons, containers must be built from **either the penultimate stable version of Alpine or Debian**. (Your choice.)  
- You must **write your own Dockerfiles, one per service**. These Dockerfiles must be **called by your `docker-compose.yml`** and **invoked via your Makefile**.  
- You must **build your images yourself**. **Pulling ready-made images** or using services such as DockerHub is **forbidden** (**except** for the base images **Alpine/Debian**).  
- **Containers must restart automatically** in case of a crash.

> **Important (Daemons & PID 1)**  
> A Docker container is **not** a virtual machine. Avoid hacky patches (e.g., `tail -f` tricks) to keep processes alive. **Learn how daemons work** and follow **best practices for PID 1**.

### Services to set up

- **NGINX** with **TLSv1.2 or TLSv1.3 only** (in its own container).  
- **WordPress** with **php-fpm only** (installed and configured) **without nginx** (in its own container).  
- **MariaDB** only (without nginx) (in its own container).  
- **A volume** that contains your **WordPress database**.  
- **A second volume** that contains your **WordPress site files**.  
- **A docker network** that connects your containers.

### Networking & process rules

- Using `network: host`, `--link` or `links:` is **forbidden**.  
- A top-level `networks:` definition **must** be present in your `docker-compose.yml`.  
- Containers **must not** be started with a command that runs an **infinite loop** (including `entrypoint` or entrypoint scripts).  
  - Forbidden hacky patterns include (but are not limited to): `tail -f`, `bash` (as a long-running idle), `sleep infinity`, `while true` …  
- Read about **PID 1** and **best practices for Dockerfiles**.

### WordPress database requirements

- The WordPress database must contain **two users**, one of whom is the **administrator**.  
- The administrator’s **username must not** contain “`admin`”, “`Admin`”, “`administrator`”, or “`Administrator`” (e.g., `admin`, `administrator`, `Administrator`, `admin-123`, etc. are **forbidden**).

### Volumes on host

- Your volumes must be mounted under the host path:  
  `/**home/<login>**/data`  
  Replace `<login>` with **your 42 login**.

### Domain name & access

- Configure a domain name that **points to your local IP**, using the 42 pattern:  
  `**<login>.42.fr**` (e.g., if your login is `wil`, then `wil.42.fr` points to your host IP).  
- The **NGINX container must be the sole entry point** to your infrastructure, **accessible only via port 443** using the **TLSv1.2 or TLSv1.3** protocol.

### Tags, secrets & environment variables

- The Docker image tag `**latest**` is **prohibited**.  
- **Passwords must not** appear in your Dockerfiles.  
- The **use of environment variables is mandatory**.  
- It is **strongly recommended** to use a **`.env`** file for non-secret variables and **Docker secrets** for confidential information.

### Example architecture diagram (original page 10)

> _Description:_ A host computer runs Docker. Inside a **Docker network**, three containers communicate:  
> - **DB** (MariaDB) — exposes port **3306** internally.  
> - **WordPress + php-fpm** — listens on **9000** internally.  
> - **NGINX** — publishes **443** to the outside world (**WWW**).  
> Volumes are attached for **DB data** and **WordPress files**.

```

```
                 WWW
                  │
                (443)
                  │
           +-------------+
           |  NGINX      |  <-- container (TLS 1.2/1.3) — publishes 443
           +-------------+
                  ▲
                  │ (internal network)
```

+-----------+      │       +-----------------------+
|  DB       |<-----┼-----> | WordPress + PHP-FPM   |
| (3306)    |              | (9000)                |
+-----------+              +-----------------------+

Volumes:

* db volume  -> DB container data
* wp volume  -> WordPress site files

````

### Example expected directory structure (original page 11)

```console
$> ls -alR
total XX
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 .
drwxrwxrwt 17 wil wil 4096 avril 42 20:42 ..
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Makefile
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 secrets
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 srcs

./secrets:
total XX
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 6 wil wil 4096 avril 42 20:42 ..
-rw-r--r-- 1 wil wil XXXX avril 42 20:42 credentials.txt
-rw-r--r-- 1 wil wil XXXX avril 42 20:42 db_password.txt
-rw-r--r-- 1 wil wil XXXX avril 42 20:42 db_root_password.txt

./srcs:
total XX
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 ..
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 docker-compose.yml
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .env
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 requirements

./srcs/requirements:
total XX
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 ..
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 bonus
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 mariadb
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 nginx
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 tools
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 wordpress

./srcs/requirements/mariadb:
total XX
drwxrwxr-x 4 wil wil 4096 avril 42 20:45 .
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 ..
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 conf
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Dockerfile
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .dockerignore
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 tools
[...]

./srcs/requirements/nginx:
total XX
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 ..
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 conf
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Dockerfile
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .dockerignore
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 tools
[...]
$> cat srcs/.env
DOMAIN_NAME=wil.42.fr
# MYSQL SETUP
MYSQL_USER=XXXXXXXXXXXX
[...]
$>
````

> **Security warning (original page 11)**
> For obvious security reasons, **any credentials, API keys, passwords, etc. must be saved locally** (e.g., secrets files, Docker secrets) and **ignored by git**.
> **Publicly stored credentials = immediate project failure.**

> **Tip (original page 12)**
> You can store non-secret variables (e.g., domain name) in a `.env` file.

---

## VI. Bonus part

For this project, the bonus part is intended to be **simple**.

* A **Dockerfile must be written for each additional service**. Each service runs in its **own container** and, if necessary, has its **dedicated volume**.

**Bonus list:**

* Set up **Redis cache** for your WordPress website to manage caching properly.
* Set up an **FTP server** container pointing to the **WordPress site volume**.
* Create a **simple static website** in any language **except PHP** (e.g., a personal showcase or résumé site).
* Set up **Adminer**.
* Set up **a service of your choice** that you consider useful — be ready to **justify** your choice during the defense.

> **Note**
> To complete the bonus, you may add **extra services**. In that case, you may **open more ports** as needed.

> **Assessment rule**
> The **bonus is evaluated only if the mandatory part is perfect**.
> “Perfect” means the **entire mandatory part is fully completed** and **works without any malfunctions**. If you have **not passed ALL mandatory requirements**, your bonus **will not be evaluated**.

---

## VII. Submission and peer-evaluation

* Submit your assignment to your **Git repository** as usual. **Only** the work inside your repository will be evaluated during the defense. Double-check **folder and file names**.
* During the evaluation, the reviewer may request a **brief modification** (e.g., small behavior change, a few lines of code to write/modify, or an easy-to-add feature).
* This step may **not** apply to every project, but you must be prepared **if it’s in the evaluation guidelines**.
* The goal is to **verify your understanding** of a specific part of the project.
* The modification can be performed in **any dev environment you choose** (e.g., your usual setup) and **should be feasible within a few minutes** (unless a specific timeframe is defined).
* You might be asked to change a small function or script, tweak a display, adjust a data structure to store new information, etc.
* **Details (scope, target, etc.) will be specified** in the evaluation guidelines and **may vary** from one evaluation to another for the same project.

---

### Document identifier (from the original last page)

```
16D85ACC441674FBA2DF65190663EC3C3C258FEA065D090A715F1B62F5A57F0B75403
61668BD6823E2F873124B7E59B5CE94BB7ABD71CD01F65B959E14A3838E414F1E871
F7D91730B
```

```

Source : :contentReference[oaicite:0]{index=0}

```