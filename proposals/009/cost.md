## Cost Estimation

Costs are an area where we should spend quite a bit of time and where how the architecture is built will have a significant impact. EC2 vs ECS, ECS EC2 vs ECS Fargate, S3 vs EBS, RDS vs DocumentDB - all of these will impact costs and so during the design phase, costs will need to be carefully considered.

### Cloud Service Costs

There are numerous free tools that will compare the costs of services across clouds. For example [Holori](https://app.holori.com/compare), [Cloud Comparison Tool](https://www.cloudcomparisontool.com/), or a commercial tool like [Cloudzero](https://www.cloudzero.com/) or [CloudCast](https://www2.deloitte.com/us/en/pages/consulting/solutions/cloudcast.html) by Deloitte are all useful. I would champion that we look at a commercial tool like CloudZero, but if that wasn't in the budget, build out something simple to scrape the free sites and alert us if costs varied enough to make the time/effort to migrate worthwhile.

## Total Cost of Ownership (TCO)

Aside from the relatively fixed costs of the cloud provider, storage, transit, and other miscellaneous items like support, we need to make sure that we understand the actual Total Cost of Ownership for this solution. This includes things like will we have to pay more for engineers who have multi-cloud skills because they are harder to find? Will we have issues with employee retention once they are upskilled and thus more desirable on the market? What is the on-going burden for maintenance of any custom portions of the platform? Have we built out features into the app that allow a customer to choose their platform and do we need to make sure that we stay on top of API changes so we don't suddenly have a broken feature in the application? Since we offer our customers a choice of any cloud provider and potentially any reason, how does that impact our need to stay compliant *globally*? 

[<< Return](./index.md#cost)