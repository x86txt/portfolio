These are some bash scripts I have written throughout my career.

| script name | purpose |
| ----------- | ------- |
| ```run_backup.sh```      | dump all docker container configs to a docker-compose yaml for quick restore.                           |
| ```cleanup.sh```         | sanitize an Ubuntu OS for image deployment, including the troublesome machine-id regeneration.          |
| ```set_awsHostname.sh``` | quick script I use with Puppet to get AWS EC2 'Name' tag and then set it as the hostname inside the OS. |
| ```update_cfv4_ips.sh``` | update cloudflare ips, validate subnets, create nginx config, test nginx config, reload nginx.          |
