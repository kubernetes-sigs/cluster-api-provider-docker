# Cluster API Provider Docker

## Manager Container Image

A sample is built and hosted at `gcr.io/kubernetes1-226021/capd-manager:latest`

### External Dependencies

- `go,  1.12+`
- `kubectl`
- `docker`

### Building Go binaries

Building Go binaries requires `go 1.12+` for go module support.

```(bash)
# required if `cluster-api-provider-docker` was cloned into $GOPATH
export GO111MODULE=on
# build the binaries into ${PWD}/bin
./script/build-binaries.sh
```

### Building the image

#### Using Gcloud

Make sure `gcloud` is authenticated and configured.

You also need to set up a google cloud project.

Run: `./scripts/publish-manager.sh`

#### Using Docker

Alternatively, run: `REGISTRY=<MY_REGISTRY> ./scripts/publish-manager.sh`

## Trying CAPD

Tested on Linux and MacOS with [v0.1.3](https://github.com/kubernetes-sigs/cluster-api-provider-docker/releases/tag/v0.1.3).

Make sure you have `kubectl`.

1. Install capdctl:

   `go install ./cmd/capdctl`

1. Start a management kind cluster

   `capdctl setup`

1. Set up your `kubectl`

   `export KUBECONFIG="${HOME}/.kube/kind-config-management"`

### Create a worker cluster

`kubectl apply -f examples/simple-cluster.yaml`

#### Interact with a worker cluster

The kubeconfig is on the management cluster in secrets. Grab it and write it to a file:

`kubectl get secrets -o jsonpath='{.data.value}' my-cluster-kubeconfig | base64 --decode > ~/.kube/kind-config-my-cluster`

On **MacOS**, you need to manually update the server address in the kubeconfig to point to the cluster load-balancer:
`sed -i -e "s/server:.*/server: https:\/\/$(docker port my-cluster-external-load-balancer 6443 | sed "s/0.0.0.0/127.0.0.1/")/g" ~/.kube/kind-config-my-cluster`

Look at the pods in your new worker cluster:
`kubectl get po --all-namespaces --kubeconfig ~/.kube/kind-config-my-cluster`
