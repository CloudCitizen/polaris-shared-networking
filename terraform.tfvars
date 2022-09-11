platform_domain = "cloudcitizen.eu"

vpcs = {
  "egress" = {
    cidr             = "10.100.0.0/16"
    tgw_propagations = []
    subnets = {
      public = {
        public = true
        cidrs  = ["10.100.0.0/24"]
      }
      # vpc_endpoints = {
      #   cidrs = ["10.100.5.0/24", "10.100.6.0/24", "10.100.7.0/24"]
      # }
      tgw = {
        cidrs = ["10.100.254.0/28"]
      }
    }
  }
  "ingress" = {
    cidr             = "10.101.0.0/16"
    tgw_propagations = []
    subnets = {
      public = {
        public = true
        cidrs  = ["10.101.0.0/24"]
      }
      tgw = { cidrs = ["10.101.254.0/28"] }
    }
  }

  # VPC used by several accounts (audit, logging, polaris-deploy etc)
  "polaris-shared" = {
    cidr             = "10.102.0.0/16"
    tgw_propagations = ["egress"]
    subnets = {
      private = { cidrs = ["10.102.0.0/24"] }
      tgw     = { cidrs = ["10.102.254.0/28"] }
    }
  }
}

ram_shares = {
  "polaris-deployment" = {
    principal = 860031398530
    resources = {
      polaris-shared = ["private"]
    }
  }
}

vpc_endpoint_vpc    = "egress"
vpc_endpoint_subnet = "vpc_endpoints"
vpc_endpoint_default_sg_ingress_rules = [
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["10.0.0.0/8"]
  }
]

vpc_endpoints = {}

# vpns_config = [
#   {
#     name                   = "nonsensitive-vpn"
#     vpc_name               = "plt-nonsensitive-vpn"
#     client_cidr_block      = "172.18.0.0/16"
#     saml_metadata_document = "saml_app_aws_client_vpn_nonsensitive_metadata"
#     server_common_name     = "nonsensitive.vpn.tmnl.nl"
#     authorization_rules = [
#       {
#         target_network_cidr  = "10.0.0.0/8"
#         authorize_all_groups = true
#         name                 = "allow_all"
#         description          = "Allow all traffic"
#         access_group_id      = null
#       },
#       {
#         target_network_cidr  = "172.17.0.0/16"
#         authorize_all_groups = true
#         name                 = "allow_all"
#         description          = "Allow VPC traffic"
#         access_group_id      = null
#       }
#     ]
#   },
#   {
#     name                   = "sensitive-vpn"
#     vpc_name               = "plt-sensitive-vpn"
#     client_cidr_block      = "172.20.0.0/16"
#     saml_metadata_document = "saml_app_aws_client_vpn_sensitive_metadata"
#     server_common_name     = "sensitive.vpn.tmnl.nl"
#     authorization_rules = [
#       {
#         target_network_cidr  = "10.0.0.0/8"
#         authorize_all_groups = true
#         name                 = "allow_all"
#         description          = "Allow all traffic"
#         access_group_id      = null
#       },
#       {
#         target_network_cidr  = "172.19.0.0/16"
#         authorize_all_groups = true
#         name                 = "allow_all"
#         description          = "Allow VPC traffic"
#         access_group_id      = null
#       }
#     ]
#   }
# ]

# custom_prefix_lists = {
#   egress_vpc_endpoints = {
#     vpc     = "egress"
#     subnets = "vpc_endpoints"
#   }
# }
