#set the descripion
export ARM_SUBSCRIPTION_ID= "6024a9fe-ffe1-4b9d-abdc-3602ebb0a582"
#set the application /environment
export TF_VAR_application_name= "danisTest"
export TF_VAR_instituion_name= "development"
#set the backend
export BACKEND_RESOURCE_GROUP="rg-terraform-state-dev"
export BACKEND_STORAGE_ACCOUNT="stbuq23adnj6"
export BACKEND_STORAGE_CONTAINER="important"
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_instituion_name
#run terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}"

terraform $*