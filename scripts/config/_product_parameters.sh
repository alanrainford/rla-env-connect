# Replace with your products abbreviation
PRODUCT_CODE="rla"

# Replace your product's name
PRODUCT_NAME="Cloud Retailer Apps"

# The AD groups owner's in a space separated list.
# This should be your own account and PA account at minimum.
# Group owners can manage user assignments to the groups.
GROUP_OWNERS="srivan.gutha@igt.com"

# Cost center for Cloud Ops - Retail Apps is 4905
COST_CODE="4905"  

#Repalce with your team email
TEAM_MAIL="igt.lottery.rlacloud@igt.com"

# If not using eastus, update the below to your d0 and d1 regions
D0_LOCATION="eastus"
D0_LOCATION_ALT="centralus"
D1_LOCATION="eastus"
D1_LOCATION_ALT="centralus"
P0_LOCATION="eastus"

# Replace the below with your d0 and d1 subscription ids
D0_SUBSCRIPTION_ID="8977b87e-3a72-4fdb-8ba3-d414379b05b3"
D1_SUBSCRIPTION_ID="7df47fe4-c325-4203-8fed-1f190fb6cacb"

# Replace the below with your overall assigned range of addresses for your product
PRODUCT_CIDR="10.235.0.0/16"
PRODUCT_IP="10.235.0.0"
PRODUCT_MASK="255.255.0.0"

# Replace the below with your planned subnets for d0
D0_AGENT_POOL_CIDR="10.235.254.0/26"
D0_BASTION_CIDR="10.235.254.64/26"
D0_AGENT_POOL_CIDR_ALT="10.235.254.128/26"
D0_BASTION_CIDR_ALT="10.235.254.192/26"

# Replace the below with your planned subnets for d1
D1_AGIC_SUBNET="10.235.177.192/27"
# The private IP normally the second to last IP in the AGIC subnet
D1_AGIC_PRIVATE_IP="10.235.177.222"
D1_AKS_SUBNET="10.235.172.0/23"
# Allocate sufficient space for at least 16 addresses with HA/replica
D1_DB_SUBNET="10.235.178.0/24"

# Replace with your projects GitHub URL
GIT_REPOSITORY="https://github.com/IGT-Lottery/rla-lpc-l1-azure-envs"

#
# No changes are likely needed to the below values
#

GENERATION_CODE="v1"
SITE_CODE="shd"
BUNIT_CODE="lot"
BUNIT_NAME="lottery"
GEO_CODE="na"

# This is IGT Active Directory tenant id
D0_TENANT_ID="eaad01fb-2d57-4fcb-a3da-338f671ebb86"

# This is the base URL for Lottery Azure DevOps projects
DEVOPS_ORG="https://dev.azure.com/IGT-Lottery/"