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

This proposal will serve to demonstrate a possible avenue of approach for instituting an application deploy solution that allows Cyware to deploy their application components into a customer-specified environment - this could be on-premise or cloud. For the purposes of this exercise, we will limit limit our cloud environments to AWS and Azure.

This solution should put a strong emphasis on limiting or eliminating the support burden on Cyware Staff, there should be an observability solution included for the client, there should be some allowance made for the client to manage basic administrative and maintenance tasks, and I will make a suggestion for a potential value-add for any clients who may want "white glove" support.

### Objectives

1. Deploy the application into a customer specified environment.
2. Allow the customer to deploy, initiate patches/upgrades, and monitor the environment.
3. Minimize support burden on Cyware staff.


[<< Return](./README.md#intro)

## 2. Technical Details

### Package Architecture

For the application packaging, we will provide two primary solutions:

1. A raw container for direct client consumption.
   - this container will have instructions for deploying single components of the full Cyware suite, or the ability to deploy them in any combination as a stack.
2. An OVA that runs Linux, a container runtime, and then runs our applications as containers within.
   - running a set of containers rather than installing applications directly into the OS eliminates almost all the nuance that would come with a client's environment and allows us to add administrative functionality and also implement very basic state configuration.

By providing two well-known and understood formats it will make upgrades and maintenance straightforward - our containerized customers will know how to pull the latest versions of a container and perform an upgrade, and for our OVA clients, we can either give them a limited SSH account that allows them to connect and upgrade the containers (backed by clear, concise documentation), or if we want a more professional look, build a small "administrative" GUI that allows the client to manage certain aspects of the VM and perform application upgrades. 

> **Note**
> See the [Maintenance](#3-maintenance) section for additional color here.

---
### Package Compilation and Validation

The compilation of the OVA and the container will be automated and tied into our existing SDLC CI/CD pipelines. We would add a set of new CI/CD actions that execute a build of the OVA and container, run a strong, comprehensive set of tests to make sure both are able to be deployed successfully, initiates a boot of the applications within both and verifies the daemons start and respond to basic communication like an HTTPS request, and if a failure is experienced, raise an alert to the DevOps and SRE Teams for investigation.

> **Important**
> These automated tests will be considered a living document and never "complete." We will slowly add more testing to catch as many things proactively as we can.

We will structure the final build of both the OVA and container to coincide with the SaaS release of our product. So, as we release a new version of the SaaS product, customers will have access to an updated OVA or container. The release of both will be part of the automated release process - for the OVA we will automate the upload of the new version to a AWS S3 bucket, fronted by Cloudfront or Cloudflare as a content-delivery network, and for the container, we will push it to Docker Hub, AWS Elastic Container Registry, and Azure Container Registry for direct client consumption.

Once the initial automation, pipelines, and testing environments are built out, unless there is an error, the burden on the Cyware DevOps and SRE teams should be virtually non-existent.

---
### Deployment

As outlined above, by limiting the packages we offer to OVA and a container, and building a robust set of automated testing pipelines, we can compile a knowledge base for our customers that covers how to deploy the OVA or container into each supported environment. There are numerous services we can utilize for this and I've personally used GitBook. They have special hooks with git repos that help to automate the updates to product documentation. They also provide the hosting, which removes that burden from Cyware Staff.

We can provide instructions via a knowledgebase for deploying into the following containerized environments, which should cover a large majority of potential use-cases:

1. Docker and Docker Compose
2. Kubernetes
3. AWS Elastic Kubernetes Service (EKS), ECS, and ECS Fargate
4. Azure Kubernetes Service and Azure Container Apps (including serverless mode)

For our OVA, we should limit our supported platforms to the three most popular hypervisors on the market and provide instructions for those:

1. VMware
2. Microsoft Hyper-V
3. Linux KVM

The instructions for deploying a container and/or OVA into these environments does not change frequently, so the maintenance and upkeep burden on Cyware staff would be extremely low. As we gain knowledge and expertise and learn what documentation tactics are successful, we can expand the number of on-prem and cloud environments if there is a need.

---
### Observability

As our observability platform, we will use the 'PLG Stack' aka [Prometheus](https://prometheus.io/), [Loki](https://grafana.com/oss/loki/), and [Grafana](https://grafana.com/grafana/). 

<p align="center">
<img src="./assets/grafana-node-stats.gif" alt="animated example of grafana node stats with logs" style="width:862px; height:427px; border: 1px solid black; box-shadow: 5px 5px 5px #999">
</p>

We would include this as part of the overall deployment, exposed for internal client usage. How much functionality we wanted to expose to the customer would need to be discussed and the potential for generating support queries considered, but at a minimum we could include a set of pre-built dashboards to monitor resource usage and to proactively analyze application logs for issues that we know about. 

Exposing the ability for customers to enter an email address for alerts and the webhook functionality of Grafana would be very useful and limit the need to engage Cyware staff for assistance.

As we learn about new issues in the normal course of business by running our SaaS application, we would update the Grafana logic and include it via our standard version release cycle, included with the overall package release and brought to the customers attention via our release notes.

## 3. Maintenance

This solution would offload the majority of the maintenance burden to the client and give Cyware confidence that if a customer does perform an upgrade, we have tested the latest version extensively before release. 

As noted in the [Package Architecture](#package-architecture) section, if we wanted to provide a more polished, professional look for the OVA, and this of course could be extended to our containerized clients as well, we could look at using one of the numerous off the shelf control panels, customized to just the functionality we wanted to expose, such as application start/stop, certificate injection, application upgrades (via containers under the hood), log file shipping, and/or reboot of the entire application VM. 

I understand that Cyware has extensive Django experience, so we could build this out using any of the numerous 'admin panel' projects - something like the [Django Control Center](https://github.com/byashimov/django-controlcenter) would probably work great for our needs. If not, a generic Linux control panel like [Cockpit](https://cockpit-project.org/) or [TinyCP](https://tinycp.com/) could be skinned to look very professional and polished.

If we have customers who want a more "white-glove" approach, there is an opportunity to build out a 'Professional Services' group within Cyware that can handle that and potentially several other offerings. See the [Value Adds](#value-adds) section for more on this.

[<< Return](./README.md#maintenance)

## 4. Support

By going with two well known packaging solutions - OVA and container - the bulk of the support burden will be in the up-front generation of a comprehensive knowledge base. However, this can be built-out concurrently with the provisioning and deployment of our testing environment to make better use of our staff's time.

Since we are including an observability stack, if we are contacted with issues we can have customers send us exactly the information we need, which will greatly speed MTTR (Mean Time to Resolution). For example, we can ask the customer to send us a screenshot of a particular dashboard, to export a subset or even an entire set of logs, or open a screen-sharing session so we can see the environment directly.

[<< Return](./README.md#support)

## 5. Compliance

This would be a great discussion to have with Cyware Legal or Compliance Teams, but with as long as we choose sane defaults such as requiring HTTPS, making sure disk at-rest in the default, in-transit encryption is in-use between all the components, provide a way for our clients to upload and make use of their own certificates, and allow them to export their logs to the destination of their choice, most compliance situations should be covered. 

We can address any one-off requirements as they arise and will make sure we keep a section in our knowledgebase in case any other customers are also subject to the same requirement.

[<< Return](./README.md#compliance)

## 6. Value Add

For clients who want additional support from Cyware, we could offer the ability for their PLG stack to export resource or log data to a PLG Stack that we control. Ideally, this would be single-tenant for compliance reasons and would be negotiated as part of the sales process.

For this particular value add, the support and maintenance burden on Cyware staff can be kept to a minimum by utilizing Grafana Cloud and generating a re-usable [Terraform module](https://grafana.com/docs/grafana-cloud/developer-resources/infrastructure-as-code/terraform/terraform-cloud-stack/) to provision a single-tenant environment for a customer, with a URL masked to be from Cyware - for example mattevans.support.cyware.com as opposed to tenant123.dfgt.cloud.grafana.com. We could work with our marketing and/or design team to create a generic skin for the portal, so unless a client looked deeply, it would look like part of our application stack.

Another option would be to roll the PLG backend ourselves using the open source versions of Prometheus, Loki, and Grafana and automate it via Terraform or even Ansible.

As always, my team and I would do an analysis of both solutions, consider the pros/cons, as well as staff time, level of effort, and estimated on-going support burden, to determine which solution to pursue. That discussion would include our sales team and their opinion on whether this is something our clients would even want - it's probably not worth deploying if only a very small subset of clients are interested.

[<< Return](./README.md#compliance)

## 7. Closing

[<< Return](./README.md#closing)