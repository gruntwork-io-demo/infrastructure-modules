# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be passed in by the calling Terraform code.
# ---------------------------------------------------------------------------------------------------------------------

variable "service_name" {
  description = "The name to use for all resources created by this module, including the ECS service, ECS cluster, ALB, and so on."
  type        = string
}

variable "docker_image" {
  description = "The Docker image to run as an ECS service. Typically, the format will be repository-url/image:tag. E.g., my-company/my-image:v1.0.0"
  type        = string
}

variable "cpu" {
  description = "How many CPU units to give the ECS service. Must be one of the supported options here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-tasks-services.html#fargate-tasks-size"
  type        = number
}

variable "memory" {
  description = "How much memory to give the ECS service. Must be one of the supported options here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-tasks-services.html#fargate-tasks-size"
  type        = number
}

variable "container_port" {
  description = "The port the container listens on for HTTP requests. The ALB will be configured to send all requests to this port."
  type        = number
}

variable "desired_number_of_tasks" {
  description = "How may ECS tasks to run for this ECS service."
  type        = number
}

variable "vpc_id" {
  description = "The ID of the VPC into which to deploy all the resources created by this module, including the ECS service, ECS cluster, ALB, and so on."
  type        = string
}

variable "service_subnet_ids" {
  description = "The IDs of subnets into which to deploy the ECS service and ECS cluster. We typically recommend using the private-app subnets for your services."
  type        = list(string)
}

variable "alb_subnet_ids" {
  description = "The IDs of subnets into which to deploy the ALB. We typically recommend using the public subnets for your ALBs."
  type        = list(string)
}

#---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These values may optionally be overwritten by the calling Terraform code.
# ---------------------------------------------------------------------------------------------------------------------

variable "environment_variables" {
  description = "The environment variables to expose to the service."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "forward_rules" {
  type    = any
  default = {}

  # Each entry in the map supports the following attributes:
  #
  # OPTIONAL (defaults to value of corresponding module input):
  # - priority          [number]                    : A value between 1 and 50000. Leaving it unset will automatically set
  #                                                  the rule with the next available priority after currently existing highest
  #                                                   rule. This value must be unique for each listener.
  # - listener_arns     [list(string)]              : A list of listener ARNs to override `var.default_listener_arns`
  # - stickiness        [map(object[Stickiness])]   : Target group stickiness for the rule. Only applies if more than one
  #                                                  target_group_arn is defined.
  # - authenticate_oidc map(object)                 : OIDC authentication configuration. Only applies, if not null.
  #

  # Wildcard characters:
  # * - matches 0 or more characters
  # ? - matches exactly 1 character
  # To search for a literal '*' or '?' character in a query string, escape the character with a backslash (\).

  # Conditions (need to specify at least one):
  # - path_patterns        [list(string)]     : A list of paths to match (note that "/foo" is different than "/foo/").
  #                                            Comparison is case sensitive. Wildcard characters supported: * and ?.
  #                                            It is compared to the path of the URL, not it's query string. To compare
  #                                            against query string, use the `query_strings` condition.
  # - host_headers         [list(string)]     : A list of host header patterns to match. Comparison is case insensitive.
  #                                            Wildcard characters supported: * and ?.
  # - source_ips           [list(string)]     : A list of IP CIDR notations to match. You can use both IPv4 and IPv6
  #                                            addresses. Wildcards are not supported. Condition is not satisfied by the
  #                                            addresses in the `X-Forwarded-For` header, use `http_headers` condition instead.
  # - query_strings        [list(map(string))]: Query string pairs or values to match. Comparison is case insensitive.
  #                                            Wildcard characters supported: * and ?. Only one pair needs to match for
  #                                            the condition to be satisfied.
  # - http_request_methods [list(string)]     : A list of HTTP request methods or verbs to match. Only allowed characters are
  #                                            A-Z, hyphen (-) and underscore (_). Comparison is case sensitive. Wildcards
  #                                            are not supported. AWS recommends that GET and HEAD requests are routed in the
  #                                            same way because the response to a HEAD request may be cached.

  # Authenticate OIDC Blocks:
  # authenticate_oidc:
  # - authorization_endpoint              string     : (Required) The authorization endpoint of the IdP.
  # - client_id                           string     : (Required) The OAuth 2.0 client identifier.
  # - client_secret                       string     : (Required) The OAuth 2.0 client secret.
  # - issuer                              string     : (Required) The OIDC issuer identifier of the IdP.
  # - token_endpoint                      string     : (Required) The token endpoint of the IdP.
  # - user_info_endpoint                  string     : (Required) The user info endpoint of the IdP.
  # - authentication_request_extra_params map(string): (Optional) The query parameters to include in the redirect request to the authorization endpoint. Max: 10.
  # - on_unauthenticated_request          string     : (Optional) The behavior if the user is not authenticated. Valid values: deny, allow and authenticate
  # - scope                               string     : (Optional) The set of user claims to be requested from the IdP.
  # - session_cookie_name                 string     : (Optional) The name of the cookie used to maintain session information.
  # - session_timeout                     int        : (Optional) The maximum duration of the authentication session, in seconds.

  # Example:
  #  {
  #    "foo" = {
  #      priority = 120
  #
  #      host_headers         = ["www.foo.com", "*.foo.com"]
  #      path_patterns        = ["/foo/*"]
  #      source_ips           = ["127.0.0.1/32"]
  #      http_request_methods = ["GET"]
  #      query_strings = [
  #        {
  #           key   = "foo"  # Key is optional, this can be ommited.
  #          value = "bar"
  #        }, {
  #          value = "hello"
  #        }
  #     ]
  #   },
  #   "auth" = {
  #     priority       = 128
  #     listener_ports = ["443"]
  #
  #     host_headers      = ["intern.example.com]
  #     path_patterns     = ["/admin", "/admin/*]
  #     authenticate_oidc = {
  #       authorization_endpoint = "https://myaccount.oktapreview.com/oauth2/v1/authorize"
  #       client_id              = "0123456789aBcDeFgHiJ"
  #       client_secret          = "clientsecret"
  #       issuer                 = "https://myaccount.oktapreview.com"
  #       token_endpoint         = "https://myaccount.oktapreview.com/oauth2/v1/token"
  #       user_info_endpoint     = "https://myaccount.oktapreview.com/oauth2/v1/userinfo"
  #     }
  # }
}

variable "redirect_rules" {
  type    = map(any)
  default = {}

  # Each entry in the map supports the following attributes:
  #
  # OPTIONAL (defaults to value of corresponding module input):
  # - priority       [number]: A value between 1 and 50000. Leaving it unset will automatically set the rule with the next
  #                         available priority after currently existing highest rule. This value must be unique for each
  #                         listener.
  # - listener_arns [list(string)]: A list of listener ARNs to override `var.default_listener_arns`
  # - status_code   [string]: The HTTP redirect code. The redirect is either permanent `HTTP_301` or temporary `HTTP_302`.
  #
  # The URI consists of the following components: `protocol://hostname:port/path?query`. You must modify at least one of
  # the following components to avoid a redirect loop: protocol, hostname, port, or path. Any components that you do not
  # modify retain their original values.
  # - host        [string]: The hostname. The hostname can contain #{host}.
  # - path        [string]: The absolute path, starting with the leading "/". The path can contain `host`, `path`, and `port`.
  # - port        [string]: The port. Specify a value from 1 to 65525.
  # - protocol    [string]: The protocol. Valid values are `HTTP` and `HTTPS`. You cannot redirect HTTPS to HTTP.
  # - query       [string]: The query params. Do not include the leading "?".
  #
  # Wildcard characters:
  # * - matches 0 or more characters
  # ? - matches exactly 1 character
  # To search for a literal '*' or '?' character in a query string, escape the character with a backslash (\).
  #
  # Conditions (need to specify at least one):
  # - path_patterns        [list(string)]     : A list of paths to match (note that "/foo" is different than "/foo/").
  #                                            Comparison is case sensitive. Wildcard characters supported: * and ?.
  #                                            It is compared to the path of the URL, not it's query string. To compare
  #                                            against query string, use the `query_strings` condition.
  # - host_headers         [list(string)]     : A list of host header patterns to match. Comparison is case insensitive.
  #                                            Wildcard characters supported: * and ?.
  # - source_ips           [list(string)]     : A list of IP CIDR notations to match. You can use both IPv4 and IPv6
  #                                            addresses. Wildcards are not supported. Condition is not satisfied by the
  #                                            addresses in the `X-Forwarded-For` header, use `http_headers` condition instead.
  # - query_strings        [list(map(string))]: Query string pairs or values to match. Comparison is case insensitive.
  #                                            Wildcard characters supported: * and ?. Only one pair needs to match for
  #                                            the condition to be satisfied.
  # - http_request_methods [list(string)]     : A list of HTTP request methods or verbs to match. Only allowed characters are
  #                                            A-Z, hyphen (-) and underscore (_). Comparison is case sensitive. Wildcards
  #                                            are not supported. AWS recommends that GET and HEAD requests are routed in the
  #                                            same way because the response to a HEAD request may be cached.

  # Example:
  #  {
  #    "old-website" = {
  #      priority = 120
  #      port     = 443
  #      protocol = "HTTPS"
  #
  #      status_code = "HTTP_301"
  #      host  = "gruntwork.in"
  #      path  = "/signup"
  #      query = "foo"
  #
  #    Conditions:
  #      host_headers         = ["foo.com", "www.foo.com"]
  #      path_patterns        = ["/health"]
  #      source_ips           = ["127.0.0.1"]
  #      http_request_methods = ["GET"]
  #      query_strings = [
  #        {
  #          key   = "foo"  # Key is optional, this can be ommited.
  #          value = "bar"
  #        }, {
  #          value = "hello"
  #        }
  #      ]
  #    }
  #  }
}

variable "fixed_response_rules" {
  type    = map(any)
  default = {}

  # Each entry in the map supports the following attributes:
  #
  # REQUIRED
  # - content_type [string]: The content type. Valid values are `text/plain`, `text/css`, `text/html`, `application/javascript`
  #                          and `application/json`.
  #
  # OPTIONAL (defaults to value of corresponding module input):
  # - priority      [number]       : A value between 1 and 50000. Leaving it unset will automatically set the rule with the next
  #                                 available priority after currently existing highest rule. This value must be unique for each
  #                                 listener.
  # - listener_arns [list(string)]: A list of listener ARNs to override `var.default_listener_arns`
  # - message_body  [string]      : The message body.
  # - status_code   [string]      : The HTTP response code. Valid values are `2XX`, `4XX`, or `5XX`.
  #
  # Wildcard characters:
  # * - matches 0 or more characters
  # ? - matches exactly 1 character
  # To search for a literal '*' or '?' character in a query string, escape the character with a backslash (\).
  #
  # Conditions (need to specify at least one):
  # - path_patterns        [list(string)]     : A list of paths to match (note that "/foo" is different than "/foo/").
  #                                            Comparison is case sensitive. Wildcard characters supported: * and ?.
  #                                            It is compared to the path of the URL, not it's query string. To compare
  #                                            against query string, use the `query_strings` condition.
  # - host_headers         [list(string)]     : A list of host header patterns to match. Comparison is case insensitive.
  #                                            Wildcard characters supported: * and ?.
  # - source_ips           [list(string)]     : A list of IP CIDR notations to match. You can use both IPv4 and IPv6
  #                                            addresses. Wildcards are not supported. Condition is not satisfied by the
  #                                            addresses in the `X-Forwarded-For` header, use `http_headers` condition instead.
  # - query_strings        [list(map(string))]: Query string pairs or values to match. Comparison is case insensitive.
  #                                            Wildcard characters supported: * and ?. Only one pair needs to match for
  #                                            the condition to be satisfied.
  # - http_request_methods [list(string)]     : A list of HTTP request methods or verbs to match. Only allowed characters are
  #                                            A-Z, hyphen (-) and underscore (_). Comparison is case sensitive. Wildcards
  #                                            are not supported. AWS recommends that GET and HEAD requests are routed in the
  #                                            same way because the response to a HEAD request may be cached.

  # Example:
  #  {
  #    "health-path" = {
  #      priority     = 130
  #
  #      content_type = "text/plain"
  #      message_body = "HEALTHY"
  #      status_code  = "200"
  #
  #    Conditions:
  #    You need to provide *at least ONE* per set of rules. It should contain one of the following:
  #      host_headers         = ["foo.com", "www.foo.com"]
  #      path_patterns        = ["/health"]
  #      source_ips           = ["127.0.0.1"]
  #      http_request_methods = ["GET"]
  #      query_strings = [
  #        {
  #          key   = "foo"  # Key is optional, this can be ommited.
  #          value = "bar"
  #        }, {
  #          value = "hello"
  #        }
  #      ]
  #    }
  #  }
}

variable "force_destroy" {
  description = "A boolean that indicates whether the ALB access logs bucket should be destroyed, even if there are files in it, when you run Terraform destroy. Unless you are using this bucket only for test purposes, you'll want to leave this variable set to false."
  type        = bool
  default     = false
}