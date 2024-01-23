# Exercise #13: Convert CloudFormation Code to Terraform

* Review the `cloud_formation.yml` file provided in the lab folder
* Convert the cloud_formation to a terraform implementation that includes:
    - ACLs disabled
    - Blocks all public access
    - Enables bucket versioning
    - Enables server-side encryption with Amazon S3 managed keys and enables bucket key
* Run `terraform init` and `terraform apply` to create the bucket
* Create an S3 bucket manually through the Management Console, setting each of the properties highlighted above on the secondary bucket
* Compare your auto-generated bucket to the one you created manually. Do they look the same/have the same settings?
* Use the included test.txt file to test the versioning on your Terraform-generated bucket - upload the file to your bucket as-is, make a change, and then upload the updated version to the bucket (with the same name)

Follow along with the tutorial available at https://developer.hashicorp.com/terraform/tutorials/aws/aws-dynamodb-scale using the "Terraform Community Edition" instructions