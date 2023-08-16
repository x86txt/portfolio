| project name  | purpose |
| ------------  | ------- |
| ```goaccess``` | action to compile goaccess docker container, push to ECR, update Lambda. also inicludes a cron GHA to pull down the latest stats, ingest them, and re-publish to the web |
| ```depreview``` | action to execute the built-in github dependency review action to scan for outdated or vulnerable dependencies |
| ```sast-scan``` | this action will perform an open source sast scan on a project at commit |