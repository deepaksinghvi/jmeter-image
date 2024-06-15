# jmeter-image

JMeter base image to run jmeter by providing any external jmx file.

## Build

```
docker build -t deepaksinghvi/jmeter-image .
```

## Run

- Without any param for jmx file

```
docker run deepaksinghvi/jmeter-image
```
This would use the default jmx file which is https://raw.githubusercontent.com/deepaksinghvi/jmeter-one-off-dyno/main/test/jmeter_on_aws.jmx


- With user provided jmx file
```
docker run deepaksinghvi/jmeter-image https://raw.githubusercontent.com/deepaksinghvi/jmeter-base-image/main/tests/Demo_Test_Plan.jmx
```
This would use the jmx file provided as a param input.


## Deploy Argo to AWS and execute JMeter Task as a Argo Workflow

**Perquisites:**
- Install kubectl
- Install eksctl
- Install Argo Cli

1. Create Iam and add it as part of admin group.
<img width="1110" alt="image" src="https://github.com/deepaksinghvi/jmeter-image/assets/1555248/be638a96-f33c-4823-bd5e-73e6600a65fc">

2. Create Access Keys and export them in terminal
  ```
  export AWS_ACCESS_KEY_ID=AAIBINVALID7ZPARO74A
  export AWS_SECRET_ACCESS_KEY=YOYfq0S17wYP+Rzoq1ukLRC1INVALIDJ110dVGjo
  ```
Above are not the real keys but kept here for example.

3. Create cluster using eksctl (install if you do not have it)
  ```
  eksctl create cluster -n argo-cluster —nodegroup-name argo-ng —region us-west-2 —node-type t2.micro —nodes 2
  ```
5. Install Deploy Argo Server and Workflow-Controller
  ```
  kubectl create namespace argo
  kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v3.5.7/install.yaml
  ```
6. Create Role and Get Token to login to Argo UI
  ```
  kubectl create role argo --verb=list,update --resource=workflows.argoproj.io
  ```

  ```
  kubectl create sa argo
  ```

  ```
  kubectl create rolebinding argo —role=argo —serviceaccount=argo:argo
  ```

  ```
  kubectl apply -f - <<EOF
  apiVersion: v1
  kind: Secret
  metadata:
  name: argo.service-account-token
  annotations:
  kubernetes.io/service-account.name: argo
  type: kubernetes.io/service-account-token
  EOF
  ```

  Finally get the token:
  ```
  ARGO_TOKEN="Bearer $(kubectl get secret argo.service-account-token -o=jsonpath='{.data.token}' | base64 —decode)“
  echo $ARGO_TOKEN
  ```
8. Use the complete thing as follows for token during login to argo ui.

  ```
  Bearer <YOUR TOKEN>
  ```
9 Port forward Argo-Server to use the Argo UI locally
  ```
  kubectl -n argo port-forward svc/argo-server 2746:2746 
  ```
  You can access it using the following url
  https://localhost:2746/

10. Execute Argo Workflow tasks
    
  ```
  argo submit -n argo ./argo-workflows/execute-jmeter-argo-task.yaml
  ```


