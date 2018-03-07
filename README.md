# gke-k8s-service-account
A helper script I use for running kubectl as a service account for GKE clusters.
This is only intended for my personal use, but if anyone else happens to find this useful, that would be great.

## Prerequisites

1. [`jq`](https://stedolan.github.io/jq/download/) (OSX users can run `brew install jq`)
2. [`gcloud`](https://cloud.google.com/sdk/docs/quickstart-macos)
3. [`kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (`gcloud` users can run `gcloud components install kubectl`)

## Usage

1. Copy the contents of the `kube-service-account.sh` script to your `~/.zshrc`
2. Use `gcloud auth activate-service-account` to import service account credentials using a JSON key file
3. Run `kube-service-account` and select the credentials you want to use
4. Use `kubectlt` to run any commands yoy normally would under the context of the service account

## Example

1. Create a GKE Cluster:

    ```bash
    gcloud container clusters create kube-service-account-test \
        --project my-project \
        --zone us-central1-f \
        --cluster-version 1.8.7-gke.1 \
        --machine-type n1-standard-1 \
        --num-nodes 1 \
        --image-type COS \
        --disk-size 10
    ```
2. Add the cluster credentials to your local kubeconfig:

    ```bash
    gcloud container clusters get-credentials kube-service-account-test \
        --project my-project \
        --zone us-central1-f
    ```
3. Create a service account:

    ```bash
    gcloud iam service-accounts create test-service-account \
        --project my-project \
        --display-name test-service-account
    ```
4. Create a JSON key for the service account:

    ```bash
    gcloud iam service-accounts keys create key.json \
        --project my-project \
        --iam-account test-service-account@my-project.iam.gserviceaccount.com
    ```
5. Activate the service account credentials using the JSON key:

    ```bash
    gcloud auth activate-service-account --key-file key.json
    ```
6. Run the `kube-service-account` script to configure the `kubectlt` alias to use your service account's credentials:

    ```bash
    kube-service-account
    ```
7. Use the `kubectlt` alias to attempt to create a deployment:

    ```bash
    $ kubectlt run ubuntu --image ubuntu
    Error from server (Forbidden): deployments.extensions is forbidden: User "test-service-account@my-project.iam.gserviceaccount.com" cannot create deployments.extensions in the namespace "default": Required "container.deployments.create" permission.
    ```

## Disclaimers

I have only used / tested this in `zsh`.
