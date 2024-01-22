# Getting Set up for Exercises

In this first exercise we'll make sure that we're all set up with our AWS credentials and access to AWS, and then we'll
create a Cloud9 server/environment where we'll run further exercises.

## Log into the AWS Console

Login to your virtual machine and AWS using the links and credentials provided to you

## Launch your Environment

1. In the top bar of the AWS Console, in the center, you'll see a search box; click on it, and type "Cloud9" which will filter available services in the search list. Click on "Cloud9" which will take you to where we can create your environment.
1. Click on "Create environment"
1. Give your environment a unique name and, optionally, a description. Leave all other settings at their defaults and click "Create"
1. Wait for your environment to start. In this step, AWS is provisioning an EC2 instance on which your IDE environment will run. This gives us the distinct advantage of having a consistent and controlled environment for development regardless of client hardware and OS. It also allows us to connect to our instances and AWS's API without worrying about port availability in a corporate office. :-)
1. Click "Open" to launch your Cloud-based IDE

## Install Terraform

1. Below the Welcome Document, you should see a terminal panel
1. Feel free to resize the terminal panel to your liking
1. Navigate to https://developer.hashicorp.com/terraform/install and use the instructions available on the "Amazon Linux" tab under "Linux" to install Terraform
1. Use the following to verify the Terraform installation

```bash
terraform -v
```

If you get an error, inform your instructor.

## Pull the exercises repository

The next thing we need to do is pull this repository down so we can use it in future exercises. Run the following to 
do this:

```bash
mkdir -p workshop
cd workshop
git clone https://github.com/KernelGamut32/intro-to-terraform-public .
```

Having done all of that, we should be ready to move on!
