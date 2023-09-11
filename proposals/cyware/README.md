# Proposal for Cyware

<table align="left">
    <tr>
    <th colspan="2" style="background-color:#343434">
        <h3>Executive Summary</h3>
    </th>
    </tr>
    <tr>
        <td align="right"><b>Project Title:</b></td>
        <td align="left">Automated Application Deployment into Client Environment</td>
    </tr>
    <tr>
        <td align="right"><b>Proposed By:</b></td>
        <td align="left">Matthew Evans, Director of SRE Candidate</td>
    </tr>
    <tr>
        <td align="right"><b>Date:</b></td>
        <td align="left">September 11th, 2023</td>
    </tr>
</table>

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

<p align="left">
    <img src="https://img.shields.io/badge/version-1.0-blue">
    <img alt="GitHub last commit (branch)" src="https://img.shields.io/github/last-commit/x86txt/portfolio/cyware">
    <a href="https://creativecommons.org/licenses/by-sa/4.0/"><img src="https://img.shields.io/badge/License-CC_BY--SA_4.0-lightgrey.svg?style=flat-square" alt="Attribution-ShareAlike 4.0 International"></a>
</p>

## Table of Contents

[**1. Introduction**](#1-introduction)<a id='intro'></a>
   - [Background, Context, Assumptions](#background-context-assumptions)
   - [Objectives](#objectives)

[**2. Technical Details**](#2-technical-details)<a id='tech'></a>
   - [Package Architecture](#package-architecture)
   - [Package Compilation and Validation](#package-compilation-and-validation)
   - [Deployment](#deployment)
   - [Observability](#observability)

[**3. Maintenance**](#2-maintenance)<a id='maintenance'></a>

[**4. Compliance**](#4-compliance)<a id='compliance'></a>

[**5. Support**](#5-support)<a id='support'></a>

[**6. Value Adds**](#6-value-adds)<a id='value'></a>

[**7. Closing**](#7-closing)<a id='closing'></a>

***
## 1. Introduction

### Background, Context, Assumptions

This proposal will serve to demonstrate one possible avenue of approach for instituting an application deploy solution that allows Cyware to deploy their application components into a customer-specified environment - this could be on-premise or cloud. For the purposes of this exercise, we will limit limit our cloud environments to AWS and Azure.

This solution should put a strong emphasis on limiting or eliminating the support burden on Cyware Staff, there should be an observability solution included for the client, and I will make a suggestion for a potential value-add for any clients who may want "white glove" support.

### Objectives

1. Deploy the application into a customer specified environment.
2. Allow the customer to deploy, initiate patches/upgrades, and monitor the environment.
3. Minimize support burden on Cyware staff.


[<< Return](./README.md#intro)

## 2. Technical Details

### Package Architecture

For the application packaging, we will provide a container and an OVA that runs our containers for virtual machine environments. This will cover the vast majority of environments, independent of whether the customer wants to deploy into an on-premise datacenter or into a cloud provider. 

Further, it makes upgrades and maintenance straightforward - our containerized customers will know how to pull the latest versions of a container and upgrade those, and for our OVA clients, we can either give them a limited SSH account that allows them to connect and upgrade the containers, or if we want a more professional look, build a small "administrative" GUI that allows the client to manage certain aspects of the VM, such as the network stack, logging destination, service stop/start/restart, and of course upgrades. See the [Maintenance](#3-maintenance) section for additional color here.

We can provide instructions for deploying into the following containerized environments, which should cover a large majority of potential use-cases:

1. Docker and Docker Compose
2. Kubernetes
3. AWS Elastic Kubernetes Service (EKS), ECS, and ECS Fargate
4. Azure Kubernetes Service and Azure Container Apps (including serverless mode)

For our OVA, we should limit our supported platforms to the three most popular hypervisors on the market:

1. VMware
2. Microsoft Hyper-V
3. Linux KVM

The instructions for deploying a container and/or OVA into these environments does not change frequently, so the maintenance and upkeep burden on Cyware staff would be extremely low.

### Package Compilation and Validation

The compilation of the OVA and the container will be automated and tied into our existing SDLC CI/CD pipelines. We would add a new CI/CD action that executes a build of the OVA and container, runs a set of brief tests to make sure both are deployed correctly, boots both and verifies the application daemon starts and responds to basic communication like an HTTPS request, and if a failure is experienced an alert will be raised to the DevOps and SRE Teams for investigation.

We will structure the final build of both the OVA and container to coincide with the SaaS release of our product. So as we release a new version of the SaaS product, customers will have access to an updated OVA or container. The release of both will be part of the automated release process - for the OVA we will automate the upload of the new version to a simple AWS S3-backed content-delivery network, and for the container, we will push it to Docker Hub, AWS Elastic Container Registry, and Azure Container Registry for client consumption.

Once the initial automation, pipelines, and testing environments are built out, unless there is an error, the burden on the Cyware DevOps and SRE teams should be virtually non-existent.

### Deployment

As outlined above, by limiting the packages we offer to OVA and a container, and building a robust set of automated testing pipelines, we can compile a knowledge base for our customers that covers how to deploy the OVA or container into each supported environment. There are numerous services we can utilize for this and I've personally used GitBook. They have special hooks with git repos that help to automate the updates to product documentation. They also provide the hosting, which removes that burden from Cyware Staff.


### Observability

As our observability platform, we will use the 'PLG Stack' aka [Prometheus](https://prometheus.io/), [Loki](https://grafana.com/oss/loki/), and [Grafana](https://grafana.com/grafana/). 

We would include this as part of the overall deployment, for internal client usage. How much functionality we wanted to expose to the customer would need to be discussed and the potential for generating support queries considered, but at a minimum we could include a set of pre-built dashboards to monitor resource usage and to proactively analyze application logs for issues that we know about. Exposing the ability for customers to enter an email address for alerts and the webhook functionality of Grafana would be very useful and limit any potential engagement of Cyware staff for assistance.

As we learn about new issues in the normal course of business, we would update the Grafana logic and include it via our standard version release cycle, included with the overall package release and brought to the customers attention via our release notes.

## 3. Maintenance

This solution would offload the majority of the maintenance burden to the client and give Cyware confidence that if a customer does perform an upgrade, we have tested the latest version extensively before release. 

As noted in the [Package Architecture](#package-architecture), if we wanted to provide a moe polished, professional look for the OVA, and this of course could be extended to our containerized clients as well, we could look at using one of the numerous off the shelf control panels, customized to just the functionality we wanted to expose, such as application start/stop, certificate injection, application upgrades (via containers under the hood), log file shipping, and/or reboot of the entire application VM. 

I understand that Cyware has extensive Django experience, so we could build this out using any of the numerous 'admin panel' projects - something like the [Django Control Center](https://github.com/byashimov/django-controlcenter) would probably work great for our needs. If not, a generic Linux control panel like [Cockpit](https://cockpit-project.org/) or [TinyCP](https://tinycp.com/) could be skinned to look very professional and polished.

If we have customers who want a more "white-glove" approach, there is an opportunity to build out a 'Professional Services' group within Cyware that can handle that and potentially several other offerings. See the [Value Adds](#value-adds) section for more on this.

[<< Return](./README.md#maintenance)

## 4. Support

By going with two well known packaging solutions - OVA and container - the bulk of the support burden will be in the up-front generation of a comprehensive knowledge base. However, this can be built-out concurrently with the provisioning and deployment of our testing environment to make better use of our staff's time.

Additionally, if a customer chooses to take advantage of our PLG integration, we can generate webhooks that can take action - this could be a container redeploy or a VM restart. There is a world of possibility here depending on the specifics of the application. It will fall to our engineers and support staff to keep keep a database of these and then for the DevOps and SRE teams to turn those into an actionable webhook.

[<< Return](./README.md#support)

## 5. Compliance

I believe that compliance will largely be a non-issue, except for enabling centralized logging of client data into our datacenter. This would be a great discussion to have with Cyware Legal or Compliance Teams, but I feel we'd have to engineer a way to disable the logging. There are two approaches we can take, for the container just read an environment variable and turns it on or off, and for the OVA we would build-in a deploy-time switch that allowed the customer to enable or disable the log-shipping to us.

[<< Return](./README.md#compliance)

## 6. Value Add

For clients who want additional support from Cyware, we could offer the ability for their PLG stack to export data to a PLG Stack that we control. Ideally, this would be single-tenant for compliance reasons and would be negotiated as part of the sales process.

The support and maintenance burden on Cyware staff can be kept to a minimum by utilizing Grafana Cloud and generating a re-usable Terraform module to provision a single-tenant environment for a customer, with a URL masked to be from Cyware - for example mattevans.support.cyware.com as opposed to tenant123.dfgt.cloud.grafana.com. We could work with our marketing and/or design team to create a generic skin for the portal, so unless a client looked deeply, it would look like part of our application stack.

Another option would be to roll the PLG backend ourselves using the open source versions of Prometheus, Loki, and Grafana.

As always, my team and I would do an analysis of both solutions, consider the pros/cons, as well as staff time, level of effort, and estimated on-going support burden, to determine which solution to pursue. That discussion would include our sales team and their opinion on whether this is something our clients would even want - it's probably not worth deploying if only a very small subset of clients are interested.

[<< Return](./README.md#compliance)

## 7. Closing

[<< Return](./README.md#closing)