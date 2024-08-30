# About
A Docker Compose support stack for Promstack.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/c9d17547-df5a-47be-9c2c-e4fa280716f5">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/d7089364-3757-4bb9-8804-0e4b6016a30b">
  <img src="https://github.com/user-attachments/assets/d7089364-3757-4bb9-8804-0e4b6016a30b">
</picture>

## Concepts

This section covers some concepts that are important to understand for day to day Promstack usage and operation.

### Prometheus

By design, the Prometheus server is configured to automatically discover and scrape the metrics from the Docker Swarm nodes, services and tasks. You can use Docker object labels in the deploy block to automagically register services as targets for Prometheus. It also configured with config provider and config reloader services.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/59d6c0ec-d24a-443d-8cfe-4e85f296578b">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/4e17f0d7-22d1-44d7-9318-d5e58baf9580">
  <img src="https://github.com/user-attachments/assets/4e17f0d7-22d1-44d7-9318-d5e58baf9580">
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

The support for Docker Containers and Docker Compose projects made possible by running additional Prometheus services in Agent mode. The metrics collected by the Prometheus Agent are then pushed to the Prometheus server for visualization and monitoring. (For more information about Prometheus Agent, see https://prometheus.io/blog/2021/11/16/agent/).

| Kubernetes   | Docker                                                                                   |
| ------------ | ---------------------------------------------------------------------------------------- |
| `namespace`  | `__meta_docker_container_label_com_docker_compose_project`                               |
| `deployment` | `__meta_docker_container_label_com_docker_compose_project`                               |
| `pod`        | `{{service_name}}.{{__meta_docker_container_label_com_docker_compose_container_number}}` |
| `task`       | `{{service_name}}.{{__meta_docker_container_label_com_docker_compose_container_number}}` |

* The **service_name** is a combination of the compose project and service name.

## Pre-requisites

- Docker running Swarm mode
- A Docker Swarm cluster with at least 3 nodes
- The [Promstack](https://github.com/swarmlibs/promstack) is required

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

## Prometheus

By design, the Prometheus agent is configured to automatically discover and scrape the metrics from the Docker Containers and Docker Compose projects.

You can use Docker object labels in the `label` block to automagically register services as targets for Prometheus.

#### Register services as Prometheus targets

- `io.prometheus.enabled`: Enable the Prometheus scraping for the service.
- `io.prometheus.job_name`: The Prometheus job name. Default is `<docker_compose_project>/<docker_compose_service>`.
- `io.prometheus.scrape_scheme`: The scheme to scrape the metrics. Default is `http`.
- `io.prometheus.scrape_port`: The port to scrape the metrics. Default is `80`.
- `io.prometheus.metrics_path`: The path to scrape the metrics. Default is `/metrics`.
- `io.prometheus.param_<name>`: The Prometheus scrape parameters.

**Example:**

```yaml
# Annotations:
services:
  my-app:
    # ...
    labels:
      io.prometheus.enabled: "true"
      io.prometheus.scrape_port: "8080"
    networks:
      prometheus:

# As limitations of the Docker Swarm, you need to attach the service to the prometheus network.
# This is required to allow the Prometheus server to scrape the metrics.
networks:
  prometheus:
    name: prometheus
    external: true
```

# License

Licensed under the MIT License. See [LICENSE](LICENSE) for more information.
