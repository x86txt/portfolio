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
   - [Background, Context, Assumptions](#thoughts)
   - [Objectives](#object)

[**2. Technical Details**](#2-technical-details)<a id='tech'></a>
   - [Package Architecture](#packagearch)
   - [Package Compilation and Validation](#packagecompilation)
   - [Deployment](#deployment)
   - [Observability](#observe)

[**3. Maintenance**](#2-maintenance)<a id='maintenance'></a>
   - [Customer Perspective](#custper)
   - [Cyware Perspective](#cywareper)

[**4. Support**](#4-support)<a id='compliance'></a>
   - [Standard](#supportstan)
   - [White Glove Service](#supportwhite)

[**5. Security**](#5-security)<a id='securitysec'></a>

[**6. Compliance**](#5-compliance)<a id='support'></a>
   - [Customer Considerations](#custcon)
   - [Cyware Considerations](#cywarecon)

[**7. Value Adds**](#6-value-adds)<a id='value'></a>
   - [White Glove](#valwhite)
   - [Professional Services](#valprof)

[**8. Closing**](#7-closing)<a id='closing'></a>
   - [Summary Overview of Entire Solution](#closesum)
   - [My Thoughts](#closethoughts)


---
## 1. Introduction

### :thought_balloon: Background, Context, Assumptions<a id='thoughts'></a>

This proposal will serve to demonstrate a possible avenue of approach for instituting an application deploy solution that allows Cyware to deploy their application components into a customer-specified environment - this could be on-premise or cloud. For the purposes of this exercise, we will limit limit our cloud environments to AWS and Azure.

This solution should put a strong emphasis on limiting or eliminating the support burden on Cyware Staff, there should be an observability solution included for the client, there should be some allowance made for the client to manage basic administrative and maintenance tasks, and I will make a suggestion for a potential value-add for any clients who may want "white glove" support.

### :dart: Objectives<a id='object'></a>

1. Deploy the application into a customer specified environment.
2. Allow the customer to deploy, initiate patches/upgrades, and monitor the environment.
3. Minimize support burden on Cyware staff.


[<< Return](./README.md#intro)

***
## 2. Technical Details

### <img src="./assets/docker.svg?sanitize=true"> Package Architecture<a id='packagearch'></a>

For the application packaging, we will provide two primary solutions:

1. A raw container for direct client consumption.
   - this container will have instructions for deploying single components of the full Cyware suite, or the ability to deploy them in any combination as a stack.
2. An OVA that runs Linux, a container runtime, and then runs our applications as containers within.
   - running a set of containers rather than installing applications directly into the OS eliminates almost all the nuance that would come with a client's environment and allows us to add administrative functionality.

By providing two well-known and understood formats it will make upgrades and maintenance much more straightforward - our containerized customers will know how to pull the latest versions of a container and perform an upgrade, and for our OVA clients, we can either give them a limited SSH account that allows them to connect and upgrade the containers (backed by clear, concise documentation) and perform a limited set of common, administrative duties, or if we want a more professional look, build a small "administrative" GUI that allows the client to manage certain aspects of the VM and perform application upgrades. 

> **Note**
> See the [Maintenance](#3-maintenance) section for additional color here.

***
### :white_check_mark: Package Compilation and Validation<a id='packagecompilation'></a>

The compilation of the OVA and the container will be automated and tied into our existing SDLC CI/CD pipelines. We would add a set of new CI/CD actions that execute a build of the OVA and container, run a strong, comprehensive set of tests to make sure both are able to be deployed successfully, initiates a boot of the applications within both and verifies the daemons start and respond to basic communication like an HTTPS request, and if a failure is experienced, raise an alert to the DevOps and SRE Teams for investigation.

> **Important**
> These automated tests will be considered a living document and never "complete." We will slowly add more testing to catch as many things proactively as we can.

We will structure the final build of both the OVA and container to coincide with the SaaS release of our product. So, as we release a new version of the SaaS product, customers will have access to an updated OVA or container. The release of both will be part of the automated release process - for the OVA we will automate the upload of the new version to a AWS S3 bucket, fronted by Cloudfront or Cloudflare as a content-delivery network, and for the container, we will push it to Docker Hub, AWS Elastic Container Registry, and Azure Container Registry for direct client consumption.

Once the initial automation, pipelines, and testing environments are built out, unless there is an error, the burden on the Cyware DevOps and SRE teams should be virtually non-existent.

***
### <img src="./assets/github.svg?sanitize=true"> Deployment<a id='deployment'></a>

As outlined above, by limiting the packages we offer to OVA and containerized formats, and building a robust set of automated testing pipelines, we can compile a knowledge base for our customers that covers how to deploy the OVA or container into a supported environment. Due to the commonalities shared by almost all container runtimes, we will be able to support many more environments unofficially as well.

We will provide instructions via a knowledgebase for deploying into the following containerized environments, which should cover a large majority of potential use-cases:

1. Docker and Docker Compose
2. Kubernetes
3. AWS Elastic Kubernetes Service (EKS), ECS, and ECS Fargate
4. Azure Kubernetes Service and Azure Container Apps (including serverless mode)

For our OVA, we should limit our supported platforms to the three most popular hypervisors on the market and provide instructions for those:

1. VMware
2. Microsoft Hyper-V
3. Linux KVM

The instructions for deploying a container and/or OVA into these environments does not change frequently, so the maintenance and upkeep burden on Cyware staff would be extremely low. As we gain knowledge, expertise, and learn what documentations are successful, we can expand the number of on-prem and cloud environments, if we find there is a need.

***
### <img src="./assets/grafana.svg?sanitize=true"> Observability<a id='observe'></a>

As our observability platform, we will use the 'PLG Stack' aka [Prometheus](https://prometheus.io/), [Loki](https://grafana.com/oss/loki/), and [Grafana](https://grafana.com/grafana/). 

<p align="center">
<img src="./assets/grafana-node-stats.gif" alt="animated example of grafana node stats with logs" style="width:862px; height:427px; border: 1px solid black; box-shadow: 5px 5px 5px #999">
</p>

We would include this as part of the overall deployment, exposed for internal client usage. How much functionality we wanted to expose to the customer would need to be discussed and the potential for generating support queries considered, but at a minimum we could include a set of pre-built dashboards to monitor resource usage and to proactively analyze application logs for problematic situations or conditions that we are aware of. 

> **Important**
> Exposing the ability for customers to enter an email address for alerts along with the webhook functionality of Grafana would be very useful and further limit the need to engage Cyware staff for assistance.

As we learn about new issues in the normal course of business by running our SaaS application and interaction with self-deployed customers, we would update the Grafana logic and include it via our standard version release cycle, included with the overall package releases, and brought to the customers attention via our release notes. Drawing attention to this should incentivize customers to remain up-to-date and related, being able to send update notifications to our customers would be a very worthwhile pursuit and something we could explore to further enhance this offering.

***
## 3. Maintenance

### :wrench: Customer Perspective<a id='custper'></a>

This solution would offload virtually all of the maintenance burden to the client and give Cyware confidence that if a customer does perform an upgrade, we have tested the latest version extensively before release. 

As noted in the [Package Architecture](#package-architecture) section, if we wanted to provide a more polished, professional look for the OVA, and this of course could be extended to our containerized clients as well, we could look at using one of the numerous off the shelf control panels, customized to only the functionality we wanted to expose. For example functions such as application start/stop, certificate injection, application upgrades (via containers under the hood), log file shipping, backup/restore, and/or reboot of the entire application VM.

> **Note**
> I understand that Cyware has extensive Django experience, so we could build this out using any of the numerous 'admin panel' projects - something like the [Django Control Center](https://github.com/byashimov/django-controlcenter) would probably work great for our needs. If not, a generic Linux control panel like [Cockpit](https://cockpit-project.org/) or [TinyCP](https://tinycp.com/) could be skinned to look very professional and polished.

If we have customers who want a more "white-glove" approach, there is an opportunity to build out a 'Professional Services' group within Cyware that can handle that and potentially several other offerings. See the [Value Adds](#value-adds) section for more on this.

***
### :nut_and_bolt: Cyware Perspective<a id='cywareper'></a>

From our perspective, the primary maintenance burden should not be customer-interactions, but rather in making sure we keep our documentation fresh, constantly seek to improve our automated testing pipelines to proactively catch as many failure or error scenarios as possible, and of course work to improve any automated remediations we can build into the OVA solution. We should manually review the containers on a set schedule to make sure that any components used (dependencies, major version of components used) are up-to-date and do not suffer any known security vulnerabilities. We should lean primarily on automation here to notify us outside our manual checks by using dependency scanning tools, for example GitHub Dependabot.

[<< Return](./README.md#maintenance)

***
## 4. Support

### :repeat: Standard<a id='supportstan'></a>

Standard support will be handled by a set of well-organized knowledgebase articles. By going with two well known packaging solutions - OVA and container - the bulk of the support burden will be in the up-front generation of a comprehensive knowledge base. However, this can be built-out concurrently with the provisioning and deployment of our testing environment to make better use of our staff's time. I'm a firm believer that if you put the effort into making your documentation useful, do not let it 'rot' and become stale, and make it visually pleasing, people will use it. 

For building the knowledgebase, I would recommend GitBook. They utilize a git-like collaboration flow and provide hosting as part of the package, offloading that responsibility from the Cyware staff. However, if Cyware has an existing tool for public documentation, I would recommend we utilize that to avoid duplication of effort that comes with the maintenance of two independent systems, and would also serve to keep our external communication presented in a more unified manner.

Finally, by including an observability stack, we can build a set of relevant dashboards and generate alerts for known problematic situations, surfacing those to the client themselves with suggested courses of action to resolve, before they develop into an issue that results in application failure or contacting Cyware Staff.

***
### :necktie: White Glove Service<a id='supportwhite'></a>

I believe there will always be a need to serve customers who want more hand-holding, aka "white glove" support. If we are amenable to this as an organization, I think we should dive in and build out a full-blown Professional Service Group. Please see the [Value Adds](#6-value-adds) section for more information around my thoughts.

[<< Return](./README.md#support)

***

### 5. Security<a id='securitysec'></a>

Security for the solution will be handled by following best-practices at build and run time, comprehensive testing and vulnerability scanning in our build and deploy pipelines, and exposing logs and an audit-ready dashboard to the customer for actionable items.

1. Updates will be easy and straight-forward to release and since our entire packaging and release pipeline will be automated, can be put out as frequently as we desire.
2. Follow all container best practices
   - such as running the containers and embedded applications as limited users
   - limiting the attack surface to necessary services only
   - disabling unused components
   - use 'cap drop' to drop all capabilities and only add back the ones necessary for functionality
   - ensure security modules (AppArmor, SELinux, etc.) are enabled and functional and any other best practice that are specific to the applications and runtime we are using.
3. For the OVA, implement a state configuration tool (Ansible, Puppet) that ensures that any modifications would be quickly reported and then reverted.
4. Encrypt 'all-the-things!' at-rest and in-transit.
5. Include an auditing and alerting dashboard in the PLG stack, to promote visibility to the customer.

## 6. Compliance

### :briefcase: Customer Considerations<a id='custcon'></a>

This would be a great discussion to have with Cyware Legal or Compliance Teams, but at a minimum we should choose sane defaults, such as:

1. requiring HTTPS
2. making sure disk at-rest encryption is the default
3. in-transit encryption is in-use between all the components
4. provide a way for our clients to upload and make use of their own certificates
5. and allow them to export their logs to the destination of their choice

If clients have a need to provide audit reports out of the container environment or OVA, we can build in "audit report" export functionality via tools like [OpenSCAP](https://www.open-scap.org/) or [Puppet Comply](https://www.puppet.com/products/puppet-enterprise/puppet-comply), with configuration compliance provided by the container yaml or a "clean" run of Ansible or Puppet  scripts.

That should cover most compliance situations and give us a great head start on any clients who have complex compliance needs.

There will inevitably be one-off requirements that arise and so will make sure we keep a section in our knowledgebase in case any other customers are also subject to the same requirement. BY running everything a container we have the ability to easily extend the bare container or the OVA with one-off customer-specific tools for immense flexibility.

***
### :exclamation: Cyware Considerations<a id='cywarecon'></a>

By the nature of the solution being deployed into the customer's cloud or datacenter, Cyware should not have any compliance exposure. If we move forward with a value-added log ingestion option for clients who want white-glove service, we would want to make sure to pursue the single-tenant PLG stack suggestion for customers. We could then make sure the environments are complaint with any standards our customers need like SOC2, ISO27001, PCI, and many others. Keeping a very verbose due-diligence questionnaire (DDQ) on-hand and up-to-date would serve to answer many compliance related auditor questions in advance. 

[<< Return](./README.md#compliance)

***
## 7. Value Adds

### :necktie: White Glove<a id='valwhite'></a>

For clients who want additional support from Cyware, we could offer the ability for their PLG stack to export resource or log data to a PLG Stack that we control. Ideally, this would be single-tenant for compliance reasons and would be negotiated as part of the sales process.

For this particular value add, the support and maintenance burden on Cyware staff can be kept to a minimum by utilizing Grafana Cloud and generating a re-usable [Terraform module](https://grafana.com/docs/grafana-cloud/developer-resources/infrastructure-as-code/terraform/terraform-cloud-stack/) to provision a single-tenant environment for a customer, with a URL masked to be from Cyware - for example [https://mattevans.support.cyware.com](https://mattevans.support.cyware.com) as opposed to [https://tenant123.dfgt.cloud.grafana.com](https://tenant123.dfgt.cloud.grafana.com). We could work with our marketing and/or design team to create a generic skin for the portal, so unless a client looked deeply, it would look and function like part of our application stack.

Another option would be to roll the PLG backend ourselves using the open source versions of Prometheus, Loki, and Grafana and automate the environment creation via Terraform or even Ansible. Once the contract with the client has been negotiated, we would execute our provisioning scripts and just pass the resulting URL to the client, who then enters it as an environment variable to their container, or via our admin panel or through limited SSH to the OVA.

As always, my team and I would do an analysis of both solutions, consider the pros/cons, as well as staff time, level of effort, and estimated on-going support burden to determine which solution to pursue. That discussion would include our sales team and their opinion on whether this is something our clients would even want - it's probably not worth deploying if only a very small subset of clients are interested.

***
### :moneybag: Professional Services<a id='valprof'></a>

Another thought would be to start a *Professional Services* group within Cyware that offers these white glove services, as well as consulting and training on our platform, and perhaps even information security in general. We could tap internal expertise and leverage existing leadership (I have built and led professional services divisions in the past) until such a time as the revenue it is generating warrants bringing in dedicated leadership. I have used professional services from organizations like MongoDB, RSA, IBM, VMware, AWS, and Puppet and they seemed as-if they generated an immense amount of revenue with not very much overhead.

[<< Return](./README.md#compliance)

***
## 8. Closing

### :raised_hands: Summary Overview of Entire Solution<a id='closesum'></a>

We would offer two deployment methods, one via a container and another via an OVA, which would consist of an off-the-shelf Linux distro with a container runtime, running the same containers that we build and offer for stand-alone deployment. 

Inside the OVA we could package the PLG stack for monitoring and observability and include documentation in our knowledgebase for any stand-alone container consumers who might want to benefit from it as well. 

We would explore including a simple control panel based on a modified Admin Panel project, which would allow OVA customers to perform basic administrative functions for the deployed VM. If a customer deploys the OVA we could incorporate automated remediations for known-issues via PLG Actions (via simple bash scripts or Ansible), making sure to highlight those new automated remediations in our release notes.

The build of the container and OVA would be integrated into our existing CI/CD pipelines and would include robust automated testing for both compilation, deployment, and application runtime. We would incorporate vulnerability and dependency scanning checks to make sure we're shipping secure and up-to-date versions of all components, and offer the ability for clients to exert minimal control over the environment to address compliance needs. We would include an audit reporting tool like OpenSCAP and some sort of state configuration solution inside the OVA so customers can perform self-service auditing and report generation from the environment.

The push to our CDN and container repositories would likewise integrated into our existing pipelines, both needing sign-off from any necessary stakeholders before any release. This would ensure that any release of the container or new download of the OVA would coincide with a release of our SaaS platform, helping to eliminate fragmentation and the burden of having to support multiple versions of the product.

Finally, we would develop a comprehensive public knowledgebase that we create concurrently as we build out the two solutions and necessary testing and support infrastructure. This documentation would be kept updated and revised as new information comes in - either as we run our SaaS platform (aka "dog fooding"), or as clients reach out for support.

***
### :wave: My Thoughts<a id='closethoughts'></a>

I hope this proposal not only feels complete, well-thought out, and forward thinking, but shows my thought process when approached to solve a business problem. I am a firm believer that robust documentation which is clear, concise, and visually pleasing *will be read and used* by end-users and two examples of this are included below. For context, I was approached by the Business Development Team at Prometheus, asking for something they could present to a non-technical audience that would clearly convey our infrastructure and security posture, but be something non-techies would actually want to *read.*

<a href="./assets/Prometheus%20Infrastructure%20Overview.pdf"><img src="./assets/adobe.svg">Example 1: Infrastructure Overview</a>

<a href="./assets/Prometheus Security Overview.pdf"><img src="./assets/adobe.svg">Example 2: Security Overview</a>

I'd like to close by saying I have become excited to be a part of Cyware. I feel that as a humble, hands-on leader who has led several successful teams and always been reviewed extremely highly by my team, I bring a lot of value and experience, and I can help be a part of the broader organization and take Cyware to the next-level. 

I have close to two decades of infrastructure, cloud, DevOps, SRE, and Security experience, as well as an infectious enthusiasm for what I do. I take immense pride in my work and set correspondingly high-standards for myself and my team, but also understand work/life balance and take care to avoid burnout, both of myself and my team. I possess a 'lead from the front, down-in-the-trenches with my team' leadership style, am skilled at conflict resolution, communicate well with tchnical and non-technical colleagues, and have a strong sense of emotional intelligence. I believe in fostering a strong and collaborative culture, which it is very evident Cyware already has!

Finally, if you haven't seen how others feel about my technical skills or leadership ability, I would encourage you to check-out my [LinkedIn Recommendations](https://www.linkedin.com/in/mevanssecurity/). I'm happy to provide personal and professional references to you as well!

Thank you for the opportunity and I hope we speak soon!

[<< Return](./README.md#closing)