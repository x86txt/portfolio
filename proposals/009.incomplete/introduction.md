## 1. Introduction

### Background, Context, Assumptions

This proposal will serve to demonstrate one possible avenue of approach for instituting Kubernetes orchestration for Cyware's AWS
platform. As noted during my discussion with Jordan McPeek, Cyware is interested in implementing an orchestration tool to replace Docker Swarm, and Kubernetes has been identified as the most desireable candidate. 

Throughout this proposal there will be numerous assumptions made since I have no knowledge of the specifics of the current Cyware platform. However, Jordan made it clear that Cyware's apprciates forward-thinking that doesn't 'pain them into a technological corner,' and as such,
I have taken the liberty of prposaing a multi-cloud solution that will also allow for FedRAMP re-use. The thought is that some government agencies might have a preference for a specific cloud provider, and Cyware should be rrady to meet that need.

### Objectives

The objectives of this proposal will be kept as simple and high-level as possible to demonstrate my thought process when approaching a new issue, rather than extremely specific due to lack of intimate knowledge of the Cyware platform.

Our Objectives Are:

1. Institute a more capable container orchestration platform to replace Docker Swarm.
2. Architect a state configuration mechanism to ensure consistency of deployed containers.
3. Upskill employees and support staff to ensure Cyware's support standards are met.
4. Allow for multi-cloud deployment to offer customer choice, control costs, and provide flexibility in the rare event of a major cloud outage.

[<< Return](./index.md#intro)