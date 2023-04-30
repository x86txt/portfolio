#!/bin/bash

# let's make sure our /apps folder is checked for executables first
export PATH=/apps/:$PATH

# grab all the logfiles from our s3 folder
aws s3 sync s3://secunit-cloudfrontlogs/cdn/ /tmp/logs/ --quiet

# to make the goaccess command simplier, concatenate all the logs into one big file
cat /tmp/logs/*.gz > /tmp/combined.log.gz

# let's run zcat so we don't have to extract the logs, then pipe the output to goaccess
zcat /tmp/combined.log.gz | goaccess - \
    --log-format "%d\\t%t\\t%^\\t%b\\t%^\\t%m\\t%^\\t%r\\t%s\\t%R\\t%u\\t%^\\t%^\\t%^\\t%^\\t%^\\t%^\\t%^\\t%T\\t%h\\t%K\\t%k\\t%^" \
	--date-format CLOUDFRONT \
	--time-format CLOUDFRONT \
	--ignore-crawlers \
	--ignore-status=301 \
	--ignore-status=302 \
	--keep-last=28 \
	--output /tmp/report.html

# let's copy the output html to our s3 web bucket
aws s3 cp /tmp/report.html s3://secunitio/stats/report.html --quiet

# let's clear the cloudfront cache for the report.html object
aws cloudfront create-invalidation --distribution-id E1I300YAEIBG7L --paths "/stats/report.html" --no-cli-pager
