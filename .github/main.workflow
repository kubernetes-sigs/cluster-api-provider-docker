workflow "New workflow" {
  on = "push"
  resolves = ["./scripts/publish-manager.sh"]
}

action "Docker Registry" {
  uses = "actions/docker/login@86ff551d26008267bb89ac11198ba7f1d807b699"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD", "DOCKER_REGISTRY_URL"]
}

action "push image" {
  uses = "./actions/push-image/"
  needs = ["Docker Registry"]
  env = {
    TAG = "latest"
    REGISTRY = "docker.pkg.github.com/kubernetes-sigs/cluster-api-provider-docker"
  }
}
