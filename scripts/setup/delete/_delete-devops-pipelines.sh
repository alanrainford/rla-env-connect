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
 
# action to delete pipeline folders
pipeline_folder_action() {
    local folder="$1"

    echo "Deleting pipeline folder \"$folder\""

    # Note: all pipelines in a folder are automatically deleted. 
    az pipelines folder delete \
    --path "$folder" \
    --detect false \
    --org "$DEVOPS_ORG" \
    --project "$ID" \
    --yes
}

# action to delete pipelines in folders
pipeline_file_action() {
    local path="$1"
    local parent_path="$2"

    file_name=$(basename $path ".yaml")
    pipeline_name=${file_name//[-]/ }
    pipeline_name_array=( $pipeline_name )
    pipeline_name_upper=${pipeline_name_array[@]^}
    yaml=".azuredevops/${ENV_TYPE,,}/${file_name}.yaml"

    echo "Deleting pipeline $yaml as \"$pipeline_name_upper\" to \"$parent_path\""

    PIPE_ID=$(az pipelines show \
    --name "$pipeline_name_upper" \
    --project "$ID" \
    --org "$DEVOPS_ORG" \
    --output tsv \
    --query "id")

    az pipelines delete \
    --id "$PIPE_ID" \
    --project "$ID" \
    --org "$DEVOPS_ORG" \
    --yes
}

# Recursive function to iterate over directories and files
delete_pipelines() {
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
            delete_pipelines "$entry" "$parent_path" 0
        #elif [ -f "$entry" ]; then
            #pipeline_file_action "$entry" "$parent_path"
        fi
    done
}

PNAME="${PRODUCT_NAME} - ${ENV_TYPE}"
ID=$(az devops project show \
--project "$PNAME" \
--org "$DEVOPS_ORG" \
--output tsv \
--query "id")

delete_pipelines "$PIPELINE_ROOT" "" 1