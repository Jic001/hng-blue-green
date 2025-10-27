# DECISION.md

## Blue-Green Deployment Design Decisions

### 1. Nginx as a Reverse Proxy
We use Nginx to route traffic between Blue and Green application instances. It handles:

- Load balancing (primary/backup logic)
- Health checks
- Automatic failover when the active app fails

### 2. Environment Variable Templating
- `nginx.conf.template` is used along with `envsubst` to replace `$ACTIVE_POOL` dynamically.
- This allows toggling between Blue and Green without modifying the Nginx image or container.

### 3. Failover Mechanism
- Blue is the default active pool, Green is backup.
- Nginx upstreams include `max_fails` and `fail_timeout` to detect failures quickly.
- Requests are retried on the backup upstream if the primary fails (5xx or timeout), ensuring zero failed client requests.

### 4. Docker Compose Setup
- All services are orchestrated with Docker Compose.
- Blue runs on port `8081`, Green on `8082`, and Nginx on `8080`.
- The `.env` file centralizes all configuration (`ACTIVE_POOL`, `RELEASE_ID_*`, image names).

### 5. Header Preservation
- App headers (`X-App-Pool`, `X-Release-Id`) are forwarded unchanged to clients.
- This ensures that the upstream identity is visible for verification.

### 6. Reload Script
- `reload-nginx.sh` allows manual switching between Blue and Green by updating `$ACTIVE_POOL` and reloading Nginx.
- This supports testing manual toggling of pools.

### 7. Key Trade-offs
- Using `envsubst` and Compose avoids custom scripting inside the Nginx container.
- We rely on upstream failover instead of external monitoring for simplicity.
- No application code modification was necessary, adhering to the task constraints.
