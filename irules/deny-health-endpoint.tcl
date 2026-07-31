when HTTP_REQUEST {
    set path [string tolower [HTTP::path]]

    # Check if the requested path matches the restricted endpoints

    switch -glob $path {
        "/health*" -
        "/actuator/health*" -
        "*/.well-known/*" -
        "*/actuator/env*" -
        "/api/v1/health*" -
        "*/healthz*" -
        "*/healthcheck*" -
        "*/ping*" {
            # Check if the client IP is NOT in our allowed datagroup
            if { ! [class match [IP::client_addr] equals allowed_heartbeat_ips] } {
                
                # Block the request with a 403 Forbidden status
                HTTP::respond 403 content "403 Access Denied" "Content-Type" "text/plain"
                
                # Stop further processing of this request
                return
            }
        }
    }
}
