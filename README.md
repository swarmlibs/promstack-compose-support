# About
A Docker Compose support stack for Promstack

## Concepts

This section covers some concepts that are important to understand for day to day Promstack usage and operation.

### Prometheus

By design, the Prometheus server is configured to automatically discover and scrape the metrics from the Docker Swarm nodes, services and tasks. You can use Docker object labels in the deploy block to automagically register services as targets for Prometheus. It also configured with config provider and config reloader services.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/f1dd0df8-f6c8-4a9b-8398-5bb445cb197f">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/e57e363c-371a-46a8-9a10-96632639f17f">
  <img src="https://github.com/user-attachments/assets/e57e363c-371a-46a8-9a10-96632639f17f">
</picture>

**Prometheus Kubernetes compatible labels**

Here is a list of Docker Service/Task labels that are mapped to Kubernetes labels.

| Kubernetes   | Docker                                                        | Scrape config                    |
| ------------ | ------------------------------------------------------------- | -------------------------------- |
| `namespace`  | `__meta_dockerswarm_service_label_com_docker_stack_namespace` |                                  |
| `deployment` | `__meta_dockerswarm_service_name`                             |                                  |
| `pod`        | `dockerswarm_task_name`                                       | `dockerswarm/services`           |
| `service`    | `__meta_dockerswarm_service_name`                             | `dockerswarm/services-endpoints` |

* The **dockerswarm_task_name** is a combination of the service name, slot and task id.
* The task id is a unique identifier for the task. It depends on the mode of the deployement (replicated or global). If the service is replicated, the task id is the slot number. If the service is global, the task id is the node id.

### Add support for Docker Compose to Promstack

> WIP

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/891a715c-0bf8-4ffa-bb65-66cd619fd27a">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/82fb29bc-71f8-4a12-a239-733763b11ce1">
  <img src="https://github.com/user-attachments/assets/82fb29bc-71f8-4a12-a239-733763b11ce1">
</picture>

## Pre-requisites

- Docker running Swarm mode
- A Docker Swarm cluster with at least 3 nodes
- [Promstack](https://github.com/swarmlibs/promstack)

## Getting Started
To get started, clone this repository to your local machine:
```sh
git clone https://github.com/swarmlibs/promstack-compose-support.git
# or
gh repo clone swarmlibs/promstack-compose-support
```

Navigate to the project directory:
```sh
cd promstack-compose-support
```

### Deploy stack

This will deploy the stack to the Docker Swarm cluster. Please ensure you have the necessary permissions to deploy the stack and the `promstack` stack is deployed. See [Pre-requisites](#pre-requisites) for more information.

> [!IMPORTANT]
> It is important to note that the `promstack-compose-support` is the default stack namespace for this deployment.  
> It is **NOT RECOMMENDED** to change the stack namespace as it may cause issues with the deployment.

```sh
make deploy
```

### Remove stack

> [!WARNING]
> This will remove the stack and all the services associated with it. Use with caution.

```sh
make remove
```

### Verify deployment

To verify the deployment, you can use the following commands:

```sh
docker service ls --filter label=com.docker.stack.namespace=promstack-compose-support

# ID             NAME                              MODE      REPLICAS   IMAGE                     PORTS
# 5mco00qukv9b   promstack-compose-support_agent   global    1/1        prom/prometheus:v2.53.1
```

You can continously monitor the deployment by running the following command:

```sh
# The `watch` command will continously monitor the services in the stack and update the output every 2 seconds.
watch docker service ls --filter label=com.docker.stack.namespace=promstack-compose-support
```

> WIP
