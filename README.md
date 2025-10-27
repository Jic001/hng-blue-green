# Stage 2 DevOps Task - Blue/Green Deployment with Nginx

## Overview
This project demonstrates a Blue/Green deployment of a Node.js service using pre-built container images. Traffic is routed through Nginx with automatic failover and manual toggle support.

Two identical Node.js services:
- **Blue** (active by default)
- **Green** (backup)

Traffic routing and failover are handled via Nginx upstreams. Application headers are preserved.

---

## Repo Structure
