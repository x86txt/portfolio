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

---
## 1. Introduction

### :thought_balloon: Background, Context, Assumptions

This proposal will serve to demonstrate a possible avenue of approach for instituting an application deploy solution that allows Cyware to deploy their application components into a customer-specified environment - this could be on-premise or cloud. For the purposes of this exercise, we will limit limit our cloud environments to AWS and Azure.

This solution should put a strong emphasis on limiting or eliminating the support burden on Cyware Staff, there should be an observability solution included for the client, there should be some allowance made for the client to manage basic administrative and maintenance tasks, and I will make a suggestion for a potential value-add for any clients who may want "white glove" support.

### :dart: Objectives

1. Deploy the application into a customer specified environment.
2. Allow the customer to deploy, initiate patches/upgrades, and monitor the environment.
3. Minimize support burden on Cyware staff.


[<< Return](./README.md#intro)


## 2. Technical Details

### <svg role="img" fill="#2496ED" width="24px" height="24px" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M13.983 11.078h2.119a.186.186 0 00.186-.185V9.006a.186.186 0 00-.186-.186h-2.119a.185.185 0 00-.185.185v1.888c0 .102.083.185.185.185m-2.954-5.43h2.118a.186.186 0 00.186-.186V3.574a.186.186 0 00-.186-.185h-2.118a.185.185 0 00-.185.185v1.888c0 .102.082.185.185.185m0 2.716h2.118a.187.187 0 00.186-.186V6.29a.186.186 0 00-.186-.185h-2.118a.185.185 0 00-.185.185v1.887c0 .102.082.185.185.186m-2.93 0h2.12a.186.186 0 00.184-.186V6.29a.185.185 0 00-.185-.185H8.1a.185.185 0 00-.185.185v1.887c0 .102.083.185.185.186m-2.964 0h2.119a.186.186 0 00.185-.186V6.29a.185.185 0 00-.185-.185H5.136a.186.186 0 00-.186.185v1.887c0 .102.084.185.186.186m5.893 2.715h2.118a.186.186 0 00.186-.185V9.006a.186.186 0 00-.186-.186h-2.118a.185.185 0 00-.185.185v1.888c0 .102.082.185.185.185m-2.93 0h2.12a.185.185 0 00.184-.185V9.006a.185.185 0 00-.184-.186h-2.12a.185.185 0 00-.184.185v1.888c0 .102.083.185.185.185m-2.964 0h2.119a.185.185 0 00.185-.185V9.006a.185.185 0 00-.184-.186h-2.12a.186.186 0 00-.186.186v1.887c0 .102.084.185.186.185m-2.92 0h2.12a.185.185 0 00.184-.185V9.006a.185.185 0 00-.184-.186h-2.12a.185.185 0 00-.184.185v1.888c0 .102.082.185.185.185M23.763 9.89c-.065-.051-.672-.51-1.954-.51-.338.001-.676.03-1.01.087-.248-1.7-1.653-2.53-1.716-2.566l-.344-.199-.226.327c-.284.438-.49.922-.612 1.43-.23.97-.09 1.882.403 2.661-.595.332-1.55.413-1.744.42H.751a.751.751 0 00-.75.748 11.376 11.376 0 00.692 4.062c.545 1.428 1.355 2.48 2.41 3.124 1.18.723 3.1 1.137 5.275 1.137.983.003 1.963-.086 2.93-.266a12.248 12.248 0 003.823-1.389c.98-.567 1.86-1.288 2.61-2.136 1.252-1.418 1.998-2.997 2.553-4.4h.221c1.372 0 2.215-.549 2.68-1.009.309-.293.55-.65.707-1.046l.098-.288Z"/></svg> Package Architecture

For the application packaging, we will provide two primary solutions:

1. A raw container for direct client consumption.
   - this container will have instructions for deploying single components of the full Cyware suite, or the ability to deploy them in any combination as a stack.
2. An OVA that runs Linux, a container runtime, and then runs our applications as containers within.
   - running a set of containers rather than installing applications directly into the OS eliminates almost all the nuance that would come with a client's environment and allows us to add administrative functionality and also implement very basic state configuration.

By providing two well-known and understood formats it will make upgrades and maintenance straightforward - our containerized customers will know how to pull the latest versions of a container and perform an upgrade, and for our OVA clients, we can either give them a limited SSH account that allows them to connect and upgrade the containers (backed by clear, concise documentation), or if we want a more professional look, build a small "administrative" GUI that allows the client to manage certain aspects of the VM and perform application upgrades. 

> **Note**
> See the [Maintenance](#3-maintenance) section for additional color here.

### :white_check_mark: Package Compilation and Validation

The compilation of the OVA and the container will be automated and tied into our existing SDLC CI/CD pipelines. We would add a set of new CI/CD actions that execute a build of the OVA and container, run a strong, comprehensive set of tests to make sure both are able to be deployed successfully, initiates a boot of the applications within both and verifies the daemons start and respond to basic communication like an HTTPS request, and if a failure is experienced, raise an alert to the DevOps and SRE Teams for investigation.

> **Important**
> These automated tests will be considered a living document and never "complete." We will slowly add more testing to catch as many things proactively as we can.

We will structure the final build of both the OVA and container to coincide with the SaaS release of our product. So, as we release a new version of the SaaS product, customers will have access to an updated OVA or container. The release of both will be part of the automated release process - for the OVA we will automate the upload of the new version to a AWS S3 bucket, fronted by Cloudfront or Cloudflare as a content-delivery network, and for the container, we will push it to Docker Hub, AWS Elastic Container Registry, and Azure Container Registry for direct client consumption.

Once the initial automation, pipelines, and testing environments are built out, unless there is an error, the burden on the Cyware DevOps and SRE teams should be virtually non-existent.

### <svg role="img" fill="#FFFFFF" width="24px" height="24px" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/></svg> Deployment

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

### <svg role="img" fill="#F46800" width="24px" height="24px" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M23.02 10.59a8.578 8.578 0 0 0-.862-3.034 8.911 8.911 0 0 0-1.789-2.445c.337-1.342-.413-2.505-.413-2.505-1.292-.08-2.113.4-2.416.62-.052-.02-.102-.044-.154-.064-.22-.089-.446-.172-.677-.247-.231-.073-.47-.14-.711-.197a9.867 9.867 0 0 0-.875-.161C14.557.753 12.94 0 12.94 0c-1.804 1.145-2.147 2.744-2.147 2.744l-.018.093c-.098.029-.2.057-.298.088-.138.042-.275.094-.413.143-.138.055-.275.107-.41.166a8.869 8.869 0 0 0-1.557.87l-.063-.029c-2.497-.955-4.716.195-4.716.195-.203 2.658.996 4.33 1.235 4.636a11.608 11.608 0 0 0-.607 2.635C1.636 12.677.953 15.014.953 15.014c1.926 2.214 4.171 2.351 4.171 2.351.003-.002.006-.002.006-.005.285.509.615.994.986 1.446.156.19.32.371.488.548-.704 2.009.099 3.68.099 3.68 2.144.08 3.553-.937 3.849-1.173a9.784 9.784 0 0 0 3.164.501h.08l.055-.003.107-.002.103-.005.003.002c1.01 1.44 2.788 1.646 2.788 1.646 1.264-1.332 1.337-2.653 1.337-2.94v-.058c0-.02-.003-.039-.003-.06.265-.187.52-.387.758-.6a7.875 7.875 0 0 0 1.415-1.7c1.43.083 2.437-.885 2.437-.885-.236-1.49-1.085-2.216-1.264-2.354l-.018-.013-.016-.013a.217.217 0 0 1-.031-.02c.008-.092.016-.18.02-.27.011-.162.016-.323.016-.48v-.253l-.005-.098-.008-.135a1.891 1.891 0 0 0-.01-.13c-.003-.042-.008-.083-.013-.125l-.016-.124-.018-.122a6.215 6.215 0 0 0-2.032-3.73 6.015 6.015 0 0 0-3.222-1.46 6.292 6.292 0 0 0-.85-.048l-.107.002h-.063l-.044.003-.104.008a4.777 4.777 0 0 0-3.335 1.695c-.332.4-.592.84-.768 1.297a4.594 4.594 0 0 0-.312 1.817l.003.091c.005.055.007.11.013.164a3.615 3.615 0 0 0 .698 1.82 3.53 3.53 0 0 0 1.827 1.282c.33.098.66.14.971.137.039 0 .078 0 .114-.002l.063-.003c.02 0 .041-.003.062-.003.034-.002.065-.007.099-.01.007 0 .018-.003.028-.003l.031-.005.06-.008a1.18 1.18 0 0 0 .112-.02c.036-.008.072-.013.109-.024a2.634 2.634 0 0 0 .914-.415c.028-.02.056-.041.085-.065a.248.248 0 0 0 .039-.35.244.244 0 0 0-.309-.06l-.078.042c-.09.044-.184.083-.283.116a2.476 2.476 0 0 1-.475.096c-.028.003-.054.006-.083.006l-.083.002c-.026 0-.054 0-.08-.002l-.102-.006h-.012l-.024.006c-.016-.003-.031-.003-.044-.006-.031-.002-.06-.007-.091-.01a2.59 2.59 0 0 1-.724-.213 2.557 2.557 0 0 1-.667-.438 2.52 2.52 0 0 1-.805-1.475 2.306 2.306 0 0 1-.029-.444l.006-.122v-.023l.002-.031c.003-.021.003-.04.005-.06a3.163 3.163 0 0 1 1.352-2.29 3.12 3.12 0 0 1 .937-.43 2.946 2.946 0 0 1 .776-.101h.06l.07.002.045.003h.026l.07.005a4.041 4.041 0 0 1 1.635.49 3.94 3.94 0 0 1 1.602 1.662 3.77 3.77 0 0 1 .397 1.414l.005.076.003.075c.002.026.002.05.002.075 0 .024.003.052 0 .07v.065l-.002.073-.008.174a6.195 6.195 0 0 1-.08.639 5.1 5.1 0 0 1-.267.927 5.31 5.31 0 0 1-.624 1.13 5.052 5.052 0 0 1-3.237 2.014 4.82 4.82 0 0 1-.649.066l-.039.003h-.287a6.607 6.607 0 0 1-1.716-.265 6.776 6.776 0 0 1-3.4-2.274 6.75 6.75 0 0 1-.746-1.15 6.616 6.616 0 0 1-.714-2.596l-.005-.083-.002-.02v-.056l-.003-.073v-.096l-.003-.104v-.07l.003-.163c.008-.22.026-.45.054-.678a8.707 8.707 0 0 1 .28-1.355c.128-.444.286-.872.473-1.277a7.04 7.04 0 0 1 1.456-2.1 5.925 5.925 0 0 1 .953-.763c.169-.111.343-.213.524-.306.089-.05.182-.091.273-.135.047-.02.093-.042.138-.062a7.177 7.177 0 0 1 .714-.267l.145-.045c.049-.015.098-.026.148-.041.098-.029.197-.052.296-.076.049-.013.1-.02.15-.033l.15-.032.151-.028.076-.013.075-.01.153-.024c.057-.01.114-.013.171-.023l.169-.021c.036-.003.073-.008.106-.01l.073-.008.036-.003.042-.002c.057-.003.114-.008.171-.01l.086-.006h.023l.037-.003.145-.007a7.999 7.999 0 0 1 1.708.125 7.917 7.917 0 0 1 2.048.68 8.253 8.253 0 0 1 1.672 1.09l.09.077.089.078c.06.052.114.107.171.159.057.052.112.106.166.16.052.055.107.107.159.164a8.671 8.671 0 0 1 1.41 1.978c.012.026.028.052.04.078l.04.078.075.156c.023.051.05.1.07.153l.065.15a8.848 8.848 0 0 1 .45 1.34.19.19 0 0 0 .201.142.186.186 0 0 0 .172-.184c.01-.246.002-.532-.024-.856z"/></svg> Observability

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

> **Note**
> I understand that Cyware has extensive Django experience, so we could build this out using any of the numerous 'admin panel' projects - something like the [Django Control Center](https://github.com/byashimov/django-controlcenter) would probably work great for our needs. If not, a generic Linux control panel like [Cockpit](https://cockpit-project.org/) or [TinyCP](https://tinycp.com/) could be skinned to look very professional and polished.

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