provider "aws" {
  region = "eu-west-1"
}

module "ecs_clone" {
  source = "../../"
  containers = {
    "hashicorp/vault" = ["1.14", "1.13"]
  }
  build_commands = {
    "hashicorp/vault:1.14" = [
      "RUN mkdir /etc/vault",
      "RUN chmod 777 /etc/vault",
      "VOLUME [\"/etc/vault\"]"
    ],
    "hashicorp/vault:1.13" = [
      "RUN mkdir /etc/vault",
      "RUN chmod 111 /etc/vault",
      "VOLUME [\"/etc/vault\"]"
    ]
  }
}