terraform { 
required_providers {
aws = {
    source = "hashicorp/aws"
    version = "~>5.0"
    }

}

}

#default region (N.verginia)
provider "aws" {
    region = "us-east-1"
}

#alias for Singapore (used for replication bucket)
provider "aws" {
    alias = "singapore"
    region = "ap-southeast-1"
} 

