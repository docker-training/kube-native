## A simple micorservice application

This app consists of two containerized components:

 - A postgres database
 - A springboot-driven API.

This is meant to serve as a minimal but nontrivial demo app for use in containerization and orchestration education programs.

### Setup

1.  Log into whatever registry you want to host your images on, and make sure it's happy creating repositories on push.

2.  From the root of this repository (make sure to fill in the <variables> first):

    ```
    export REGISTRY=<your image registry>
    export OWNER=<your user or organization ID in your registry>
    docker image build -t ${REGISTRY}/${OWNER}/api:0.1 api
    docker image build -t ${REGISTRY}/${OWNER}/db:0.1 database
    docker image push ${REGISTRY}/${OWNER}/api:0.1
    docker image push ${REGISTRY}/${OWNER}/db:0.1
    ```

3.  Edit the `image` entries in `app.yaml` to match your api and db image names you just pushed, and deploy with `kubectl apply -f app.yaml`.

4.  Check the port selected for your `api-ingress` service. Hit your API like `curl localhost:<port>/api/products/1`.
