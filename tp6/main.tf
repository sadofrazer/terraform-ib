module "infra1" {
    source = "../tp4"
    author = "fsa-dev"
    instance_type = "t2.micro"
    env = "dev"
}

module "infra2" {
    source = "../tp4"
    author = "fsa-prod"
    instance_type = "t2.micro"
    env = "prod"
}