## Technical Details

### Cloud Providers

For this proposal we will utilize the 3 'major' cloud providers, AWS, Azure, and GCP. However, this solution can be easily extended into other providers such as Oracle Cloud, Alibaba Cloud, IBM Cloud, or even 2nd tier providers such as Linode, Vultr, or Digital Ocean.

## Kubernetes Distribution

For this solution we will go with vanilla Kubernetes, but if this were a real proppsal there are multi-cloud Kubernetes solutions like [Anthos](https://cloud.google.com/anthos), [Kubermatic](https://www.kubermatic.com/), or [VMware Cloud Foundation](https://www.vmware.com/products/cloud-foundation.html) (just to name a few), that are absolutely worth discussing.


### Cluster Architecture

Our cluster architecture will consist of a multi-cloud control plane to ensure we can continue to manage our fleet if we suffer a single cloud provider outage, as well as multi-cloud node runtimes to distribute workloads to the cloud provider of our choice.

### Networking

We won't get into the nuance of how to best architect cross-cloud networking, but it will of course require quite a bit of thought and planning to ensure we are not overspending and communication is kept secure. I have used SDN providers like [Megaport](https://www.megaport.com/services/cloud-connectivity/), which offer fixed-cost SLA-backed transit, and if costs allow deploying a dispirate pair of those providers would be an ideal choice - but even a single provider backed by traditional IPsec tunnels would offer uptime well into the 99.99% range.

### Security

As with everything cloud, security will need to be carefully considered. Multi-Cloud deployments open multiple avenues of attack that are not well-known, so penetration testing, vulnerability scanning and management, as well as permissions and roles will have to be carefully considered.

[<< Return](./index.md)