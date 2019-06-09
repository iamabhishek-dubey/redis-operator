# Redis Operator - An easy way of deploying Redis on Kubernetes

This is Redis Operator which will create/manage Redis on the top of the Kubernetes. The project is inspired by the **[Operator Framework](https://coreos.com/operators/)** which is initiated by the **[CoreOS](https://coreos.com/)**.

## Requirements

- **Golang** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ---> If you want to do development
- **Kubernetes 1.9+** ---> This operator supports Kubernetes 1.9+ versions

## Overview

Redis Operator deploy and manage the Redis instances in form of **cluster** or **Master and Slave** depending upon on your configuration

Things you should know about Redis Operator:-

- 3 is a minimum number of Redis instances.
- Redis 5.0 is the minimum supported version.
- Redis Operator is not a distributed system. It leverages a simple leader election protocol. You can run multiple instances of Redis Operator.

The folder structure of operator is something like this:-

```s
redis-operator      ---> Main codebase directory for Redis Operator
├── build           ---> All the artifacts(binary) and Dockerfile
├── cmd             ---> Contains main.go which is the entry point to initialize and start this operator
├── deploy          ---> Contains manifests for deploying operator on kubernetes cluster
├── example         ---> Example file for deploying redis cluster
├── go.mod          ---> Go module file for dependency management
├── Gopkg.lock      ---> Lock file generated by dep for dependency management
├── Gopkg.toml      ---> Main dep file for managing go dependencies with dep
├── LICENSE         ---> Apache-2.0 License for this operator
├── pkg             ---> Contains main api and controller files for operator operations
├── vendor          ---> The golang vendor directory contains the local copies of external dependencies
└── version         ---> This directory have the version information of this operator
```

## Getting Started

### Deploying Redis Operator

- Create a namespace for **redis-operator**

```shell
kubectl create namespace redis-operator
```

- Deploy the CRDs and Operator in **redis-operator** namespace

```shell
kubectl apply -Rf deploy
```

- Check if operator is running fine or not

```shell
kubectl -n redis-operator get deployment
kubectl get pods -n redis-operator
```

### Deploying Redis

- Redis can be deployed by creating a **Redis** Custom Resource(CR).
- Create a Redis CR that deploys a 3 node Redis replication in high availablilty mode:

```shell
kubectl create -f example/deployment.yaml
```

- Wait until the redis pods are up. It will show the name for the Pod of the current master instance and the total number of replicas in the setup:

```shell
kubectl get redis example -n redis-operator
```

- Scale the deployment:

```shell
kubectl scale redis example --replicas 4 -n redis-operator
redis.opstree.com/example scaled
```

```shell
kubectl get redis example -n redis-operator
NAME      MASTER            REPLICAS   DESIRED   AGE
example   redis-example-0   4          4         24d
```

## What Redis Operator provides you?

Redis Operator creates the following resources owned by the corresponding **Redis**.

- **Kubernetes API** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ---> redis.opstree.com
- **Secret** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ---> In case password setup is enable
- **ConfigMap** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ---> For Redis Configuration Management
- **PodDisruptionBudget** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ---> For managing the Disruptions
- **StatefulSet** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ---> StatefulSets for redis cluster deployment
- **Services** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ---> For communication with redis in kubernetes cluster
    - **redis-example** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ---> covers all pods
    - **redis-example-master** &nbsp; ---> service for access to the master pod

## To Do
- [X] Implement CI pipeline for this code.
- [ ] Add the Design and Goal information in the README.
- [ ] Create test cases for the operator
