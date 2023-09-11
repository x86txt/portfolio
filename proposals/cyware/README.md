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

[**1. Introduction**](#introduction)<a id='intro'></a>
   - [Background, Context, Assumptions](#background-context-assumptions)
   - [Objectives](#objectives)

[**2. Technical Details**](#technical-details)<a id='tech'></a>
   - [Package Architecture](#package-architecture)
   - [Package Compilation and Validation](#package-compilation-and-validation)
   - [Deployment](#deployment)
   - [Observability](#observability)

[**3. Maintenance**](#maintenance)<a id='maintenance'></a>

[**4. Compliance**](#compliance)<a id='compliance'></a>

[**5. Support**](#support)<a id='support'></a>

[**6. Value Adds**](#value-adds)<a id='value'></a>

[**7. Closing**](#closing)<a id='closing'></a>

***
## 1. Introduction

### Background, Context, Assumptions

This proposal will serve to demonstrate one possible avenue of approach for instituting an application deploy solution that allows Cyware to deploy their application components into a customer-specified environment - this could be on-premise or cloud. For the purposes of this exercise, we will limit limit our cloud environments to AWS and Azure.

This solution should put a strong emphasis on limiting or eliminating the support burden on Cyware Staff, an allowance should be made for Cyware and the customer to monitor and maintain the application, and the solution should seek to protect any proprietary application IP from viewing or exfiltration from the client's environment.

### Objectives

1. Deploy the application into a customer specified environment.
2. Allow for Cyware staff or customer to deploy, initiate patches/upgrades, and monitor the environment.
3. Minimize support burden on Cyware staff.


[<< Return](./README.md#intro)

## 2. Technical Details

### Package Architecture

For the application packaging, we will provide a container and an OVA for virtual machine environments. This will cover the vast majority of environments, independent of whether the customer wants to deploy into an on-premise datacenter or into a cloud provider. 

We can provide instructions for deploying into the following containerized environments, which should cover a large majority of potential use-cases:

1. Docker and Docker Compose
2. Kubernetes
3. AWS Elastic Kubernetes Service (EKS), ECS, and ECS Fargate
4. Azure Kubernetes Service and Azure Container Apps (including serverless mode)

For our OVA, we should limit our supported platforms to the three most popular hypervisors on the market:

1. VMware
2. Microsoft Hyper-V
3. Linux KVM

### Package Compilation and Validation

By limiting our packaging to a container and an OVA, we cap the burden on the Cyware Staff.

The compilation of the OVA and the container will be automated and tied into our existing SDLC CI/CD pipelines. As I am most familiar with GitHub Actions, I would add a new action that executes a build of the OVA and container, runs a set of brief tests to make sure both are deployed correctly, boots both and verifies the application daemon starts and responds to basic communication like an HTTPS request, and if a failure is experienced an alert will be raised to the DevOps and SRE Teams for investigation.

We will structure the final build of both the OVA and container to coincide with the SaaS release of our product. So as we release a new version of the SaaS product, customers will have access to an updated OVA or container. The release of both will be part of the automated release process - for the OVA we will automate the upload of the new version to a simple AWS S3-backed content-delivery network, and for the container, we will push it to Docker Hub, AWS Elastic Container Registry, and Azure Container Registry.

Once the initial automation, pipelines, and testing environments are built out, unless there is an error, the burden on the Cyware DevOps and SRE teams should be virtually non-existent.

### Deployment

As outlined above, by limiting the packages we offer to OVA and a container, and building a robust set of automated testing pipelines, we can compile a knowledge base for our customers that covers how to deploy the OVA or container into each supported environment. There are numerous services we can utilize for this and I've personally used GitBook. They have special hooks with git repos that help to automate the updates to product documentation. They also provide the hosting, which removes that burden from Cyware Staff.


### Observability

As our observability platform, we will use the 'PLG Stack' aka Prometheus, Grafana, and Loki. For the backend, we can choose to deploy the commercial Grafana Cloud offering, or we can choose to roll-our own. I would ask my staff to work up a proposal with the pros, cons, and estimated expense of each solution. Depending on whether I have my own budget or I need to request project funding would dictate the next steps.

The PLG Stack will give us insight into resource consumption, access to logs via log shipping, and the ability to generate *intelligent* alerts based on algorithmic analysis, rather than "dumb" metrics like CPU, or memory usage. 

On the application side we can affect this by integrating a single binary (the Grafana Agent) and then sending it back to a single PLG backend, but isolated per customer via tagging. This eliminates the complexity of needing to provision an independent instance for every customer.

## 3. Maintenance

This solution would offload the majority of the maintenance burden to the client and give Cyware confidence that if a customer does perform an upgrade, we have tested them extensively before release. If we have customers who want a more "white-glove" approach there is an opportunity to build out a Professional Services group within Cyware that can handle that, potentially with several other lucrative offerings. See the [Value Adds](#value-adds) section for more on this.

[<< Return](./README.md#maintenance)

## 4. Support

[<< Return](./README.md#support)

## 5. Compliance

[<< Return](./README.md#compliance)

## 6. Value Adds

[<< Return](./README.md#compliance)

## 7. Closing

[<< Return](./README.md#closing)