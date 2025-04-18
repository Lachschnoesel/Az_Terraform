#set the descripion
export ARM_SUBSCRIPTION_ID= "6024a9fe-ffe1-4b9d-abdc-3602ebb0a582"
#set the application /environment
export TF_VAR_application_name= "danisTest"
export TF_VAR_instituion_name= "development"
#set the backend

#run terraform
terraform init \
    -backend-config="resource_group_name=rg-danisTest-development" \
    -backend-config="storage_account_name=stbuq23adnj6" \
    -backend-config="container_name=important" \
    -backend-config="key=sometests"

terraform $*