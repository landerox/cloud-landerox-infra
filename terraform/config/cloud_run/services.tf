locals {
  cloud_run_services = {
    # ===========================================================================
    # CLOUD RUN SERVICES CONFIGURATION
    # ===========================================================================
    # Define your Cloud Run Services here.
    # Use the TEMPLATE below.

    # ===========================================================================
    # TEMPLATE: Standard Service (API)
    # ===========================================================================
    # "dummy-service" = {
    #   description = "Backend API"
    #   image       = "us-docker.pkg.dev/PROJECT/REPO/IMAGE:TAG" # (Required)
    #
    #   # --- Resources ---
    #   cpu    = "1000m"  # (Optional) 1 vCPU
    #   memory = "512Mi"  # (Optional)
    #   min_instance_count = 0
    #   max_instance_count = 10
    #   cpu_idle           = true
    #
    #   # --- Networking ---
    #   ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER" # (Optional) Options: [ALL, INTERNAL_ONLY, INTERNAL_LOAD_BALANCER]
    #   vpc_connector = "projects/..."                     # (Optional) For connecting to VPC
    #
    #   # --- Advanced (Provider 7.x) ---
    #   max_instance_request_concurrency = 80
    #   timeout                          = "300s"
    #   execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    #   custom_audiences                 = ["https://custom.domain.com"]
    #
    #   # --- Probes ---
    #   liveness_probe = {
    #     http_get = { path = "/health" }
    #   }
    #   startup_probe = {
    #     initial_delay_seconds = 10
    #     http_get = { path = "/ready" }
    #   }
    #
    #   # --- Environment & Secrets ---
    #   env_vars = {
    #     "DB_HOST" = "10.0.0.5"
    #   }
    #
    #   # --- IAM ---
    #   invoker_members = ["allUsers"] # (Optional) Publicly accessible if ingress allows
    # }
  }

  cloud_run_jobs = {
    # ===========================================================================
    # Cloud Run Jobs (Batch)
    # ===========================================================================
    # "data-processor-job" = {
    #   image       = "..."
    #   max_retries = 3
    #   timeout     = "600s"
    # }
  }
}
