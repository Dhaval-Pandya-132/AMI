#!/bin/bash

packer build \
    -var 'aws_access_key='$ghaction_aws_access_key_id \
    -var 'aws_secret_key='$ghaction_aws_secret_access_key \
    -var 'prod_account_id='$aws_account_id \
    -var-file=env.json \
    ami.json