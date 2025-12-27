variable "region" {
    description = "The region to deploy the bucket to"
    type = string
    default = "ap-south-1"
}

variable "profile" {
    description = "The profile to use for the AWS CLI"
    type = string
    default = "default"
}

variable "bucket_name" {
    description = "The name of the bucket to deploy the React app to"
    type = string
    default = "vite-react-bucket-12345umesh"
}

