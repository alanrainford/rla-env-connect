#!/usr/bin/env bash

ENV_TYPE="${1:-non-production}"

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

PIPELINE_ROOT="${REPO_ROOT}/.azuredevops/${ENV_TYPE}"

pipeline_folder() {
    local path=$1
    
    folder_name=$(basename $path)
    pipeline_folder=${folder_name//[-]/ }
    pipeline_folder_array=( $pipeline_folder )
    pipeline_folder_upper=${pipeline_folder_array[@]^}

    echo $pipeline_folder_upper
}
 
# action to create pipeline folders
pipeline_folder_action() {
    local folder="$1"

    echo "Adding pipeline folder \"$folder\""

    az pipelines folder create \
    --path "$folder" \
    --description "$ID pipelines" \
    --detect false \
    --org "$DEVOPS_ORG" \
    --project "$ID" 
}

# action to create pipelines in folders
pipeline_file_action() {
    local path="$1"
    local parent_path="$2"

    file_name=$(basename $path ".yaml")
    pipeline_name=${file_name//[-]/ }
    pipeline_name_array=( $pipeline_name )
    pipeline_name_upper=${pipeline_name_array[@]^}
    pipeline_path=$(echo "$parent_path" | tr '\\' '/' | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's,^/,,')

    yaml=".azuredevops/${ENV_TYPE,,}/${pipeline_path}/${file_name}.yaml"

    echo "Adding pipeline $yaml as \"$pipeline_name_upper\" to \"$parent_path\""

    az pipelines create \
    --name "$pipeline_name_upper" \
    --folder-path "$parent_path" \
    --project "$ID" \
    --org "$DEVOPS_ORG" \
    --repository "$GIT_REPOSITORY" \
    --service-connection "$SC" \
    --skip-first-run true \
    --yaml-path "$yaml"
}

# Recursive function to iterate over directories and files
create_pipelines() {
    local current_directory="$1"
    local parent_path="$2"
    local skip_root="$3"

    if [ $skip_root != 1 ]; then
        new_path=$(pipeline_folder "$current_directory")
        parent_path="${parent_path}\\${new_path}"
        pipeline_folder_action "$parent_path"
    fi

    for entry in "$current_directory"/*; do
        if [ -d "$entry" ]; then
            create_pipelines "$entry" "$parent_path" 0
        elif [ -f "$entry" ]; then
            pipeline_file_action "$entry" "$parent_path"
        fi
    done
}

PNAME="${PRODUCT_NAME} - ${ENV_TYPE}"
ID=$(az devops project show \
--project "$PNAME" \
--org "$DEVOPS_ORG" \
--output tsv \
--query "id")

SC=$(az devops service-endpoint list \
--org "$DEVOPS_ORG" \
--project "$ID" \
--output tsv \
--query "[?type == 'GitHub'].id" | head -n 1)

create_pipelines "$PIPELINE_ROOT" "" 1