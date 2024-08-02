#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

update_file() {
echo "Initializing $1..."
sed -i "s/@PRODUCT_CODE@/${PRODUCT_CODE,,}/g" "$1"
sed -i "s/@PRODUCT_CODE_UPPER@/${PRODUCT_CODE^^}/g" "$1"
sed -i "s/@GENERATION_CODE@/${GENERATION_CODE,,}/g" "$1"
sed -i "s/@SITE_CODE@/${SITE_CODE,,}/g" "$1"
sed -i "s/@BUNIT_CODE@/${BUNIT_CODE,,}/g" "$1"
sed -i "s/@BUNIT_NAME@/${BUNIT_NAME,,}/g" "$1"
sed -i "s/@GEO_CODE@/${GEO_CODE,,}/g" "$1"
sed -i "s/@COST_CODE@/${COST_CODE,,}/g" "$1"
sed -i "s/@TEAM_MAIL@/${TEAM_MAIL,,}/g" "$1"
sed -i "s/@D0_ENV_CODE@/${D0_ENV_CODE,,}/g" "$1"
sed -i "s/@D1_ENV_CODE@/${D1_ENV_CODE,,}/g" "$1"
sed -i "s/@D0_LOCATION@/${D0_LOCATION,,}/g" "$1"
sed -i "s/@D0_LOCATION_ALT@/${D0_LOCATION_ALT,,}/g" "$1"
sed -i "s/@D1_LOCATION@/${D1_LOCATION,,}/g" "$1"
sed -i "s/@D1_LOCATION_ALT@/${D1_LOCATION_ALT,,}/g" "$1"
sed -i "s/@D0_SUB_NAME@/${D0_SUB_NAME,,}/g" "$1"
sed -i "s/@D1_SUB_NAME@/${D1_SUB_NAME,,}/g" "$1"
sed -i "s/@D0_TENANT_ID@/${D0_TENANT_ID,,}/g" "$1"  
sed -i "s/@D0_CR_NAME@/${D0_CR_NAME,,}/g" "$1"    
sed -i "s/@D0_TF_RESOURCE_GROUP@/${D0_TF_RESOURCE_GROUP,,}/g" "$1"
sed -i "s/@D0_TF_ST_ACCOUNT@/${D0_TF_ST_ACCOUNT,,}/g" "$1"
sed -i "s/@D0_TF_ST_CONTAINER@/${D0_TF_ST_CONTAINER,,}/g" "$1"
sed -i "s/@D0_SUBSCRIPTION_ID@/${D0_SUBSCRIPTION_ID,,}/g" "$1"
sed -i "s/@D1_SUBSCRIPTION_ID@/${D1_SUBSCRIPTION_ID,,}/g" "$1"
sed -i "s!@D0_AGENT_POOL_CIDR@!${D0_AGENT_POOL_CIDR}!g" "$1"
sed -i "s!@D0_BASTION_CIDR@!${D0_BASTION_CIDR}!g" "$1"
sed -i "s!@D0_AGENT_POOL_CIDR_ALT@!${D0_AGENT_POOL_CIDR_ALT}!g" "$1"
sed -i "s!@D0_BASTION_CIDR_ALT@!${D0_BASTION_CIDR_ALT}!g" "$1"
sed -i "s!@PRODUCT_IP@!${PRODUCT_IP}!g" "$1"
sed -i "s!@PRODUCT_MASK@!${PRODUCT_MASK}!g" "$1"
sed -i "s!@D1_AKS_SUBNET@!${D1_AKS_SUBNET}!g" "$1"
sed -i "s!@D1_AGIC_SUBNET@!${D1_AGIC_SUBNET}!g" "$1"
sed -i "s!@D1_DB_SUBNET@!${D1_DB_SUBNET}!g" "$1"
sed -i "s!@D1_AGIC_PRIVATE_IP@!${D1_AGIC_PRIVATE_IP}!g" "$1"
}

for f in $(find $REPO_ROOT/terraform/envs -name *.hcl)
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/.azuredevops -name *.yaml)
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/.azuredevops/scripts -name "*.sh")
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/.azuredevops/scripts -name *.conf)
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/scripts -name *.ps1)
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/scripts -name acr-create-caches.sh)
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/helm -name *.xml)
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/helm -name *.properties)
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/helm -name *.yaml)
do
  update_file "$f"
done

if [ -f "$REPO_ROOT/terraform/envs/d0-region.hcl" ]
then
  echo "Renaming d0-region.hcl to d0-${D0_LOCATION}.hcl"
  mv "$REPO_ROOT/terraform/envs/d0-region.hcl" "$REPO_ROOT/terraform/envs/d0-${D0_LOCATION}.hcl"
fi

if [ -f "$REPO_ROOT/terraform/envs/d0-region-diags.hcl" ]
then
  echo "Renaming d0-region-diags.hcl to d0-${D0_LOCATION}-diags.hcl"
  mv "$REPO_ROOT/terraform/envs/d0-region-diags.hcl" "$REPO_ROOT/terraform/envs/d0-${D0_LOCATION}-diags.hcl"
fi

if [ -f "$REPO_ROOT/terraform/envs/d0-region-alt.hcl" ]
then
  echo "Renaming d0-region-alt.hcl to d0-${D0_LOCATION_ALT}.hcl"
  mv "$REPO_ROOT/terraform/envs/d0-region-alt.hcl" "$REPO_ROOT/terraform/envs/d0-${D0_LOCATION_ALT}.hcl"
fi

if [ -f "$REPO_ROOT/terraform/envs/d0-region-diags-alt.hcl" ]
then
  echo "Renaming d0-region-diags-alt.hcl to d0-${D0_LOCATION_ALT}-diags.hcl"
  mv "$REPO_ROOT/terraform/envs/d0-region-diags-alt.hcl" "$REPO_ROOT/terraform/envs/d0-${D0_LOCATION_ALT}-diags.hcl"
fi

if [ -f "$REPO_ROOT/terraform/envs/d1-region.hcl" ]
then
  echo "Renaming d1-region.hcl to d1-${D1_LOCATION}.hcl"
  mv "$REPO_ROOT/terraform/envs/d1-region.hcl" "$REPO_ROOT/terraform/envs/d1-${D1_LOCATION}.hcl"
fi

if [ -f "$REPO_ROOT/terraform/envs/d1-region-diags.hcl" ]
then
  echo "Renaming d1-region-diags.hcl to d1-${D1_LOCATION}-diags.hcl"
  mv "$REPO_ROOT/terraform/envs/d1-region-diags.hcl" "$REPO_ROOT/terraform/envs/d1-${D1_LOCATION}-diags.hcl"
fi

if [ -d "$REPO_ROOT/helm/d1-region" ]
then
  echo "Renaming helm/d1-region to /helm/d1-${D1_LOCATION}"
  mv "$REPO_ROOT/helm/d1-region" "$REPO_ROOT/helm/d1-${D1_LOCATION}"
  CWD=$(pwd)
  cd "$REPO_ROOT"
  git add helm
  cd "$CWD"
fi

if [ -d "$REPO_ROOT/helm/d1-region-alt" ]
then
  echo "Renaming helm/d1-region-alt to /helm/d1-${D1_LOCATION_ALT}"
  mv "$REPO_ROOT/helm/d1-region-alt" "$REPO_ROOT/helm/d1-${D1_LOCATION_ALT}"
  CWD=$(pwd)
  cd "$REPO_ROOT"
  git add helm
  cd "$CWD"
fi