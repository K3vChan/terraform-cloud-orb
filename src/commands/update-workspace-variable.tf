description: |
  Updates a workspace environment variable

parameters:
    workspace-id:
        description: "Terraform worksapce id that is being updated"
        type: string
        default: ""
    variable-name:
        description: "Terraform variable id that is being updated"
        type: string
        default: ""
    variable-value:
        description: "Terraform variable id that is being updated"
        type: string
        default: ""

steps:
    - run:
        name: Update Variable
        command: |
        VARIABLE_ID=$(curl -s \
        https://app.terraform.io/api/v2/workspaces/<< parameters.workspace-id >>/vars \
        --header "Authorization: Bearer ${TF_TOKEN}" \
        | jq -r '.data[] | select(.attributes.key == "<< parameters.variable-name >>") | .id')

        CIRCLE_BUILD_NUM_DOCKER=<< parameters.variable-value >>

        REQUEST_BODY=$(echo '{"data": {"attributes": {"value": "{{BUILD_NUMBER}}"}}}' | sed s/{{BUILD_NUMBER}}/${CIRCLE_BUILD_NUM_DOCKER}/g)

        curl -X PATCH \
        https://app.terraform.io/api/v2/workspaces/<< parameters.workspace-id >>/vars/$VARIABLE_ID \
        --header "Content-Type: application/vnd.api+json" \
        --header "Authorization: Bearer ${TF_TOKEN}" \
        -d "$REQUEST_BODY"
