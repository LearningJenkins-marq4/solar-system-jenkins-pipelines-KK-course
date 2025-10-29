#! /bin/bash

set -euo pipefail

echo 'Integration Testing on EC2 (Docker container)...'

aws --version

public_dns_name=$(aws ec2 describe-instances | jq -r ' .Reservations[].Instances[] | select(.Tags[].Value == "LearningJenkins") | .PublicDnsName')
echo "URL => ${public_dns_name}"

if [[ -z $public_dns_name ]]
then
    echo "Public DNS name is empty."
    exit 1
fi

return_code=$(curl -s -o /dev/null -w "%{http_code}" http://${public_dns_name}:3000/live)
echo "Return code => ${return_code}."
planet_data=$(curl -s -X POST http://${public_dns_name}:3000/planet -H "Content-Type: application/json" -d '{"id": "3"}')
echo "Planet data => ${planet_data}."
planet_name=$(echo ${planet_data} | jq .name -r)
echo "Planet name => ${planet_name}."

if [[ "${return_code}" -eq 200 && "${planet_name}" == 'Earth' ]]
then
    echo "Tests passed!"
else
    echo "Test(s) failed!"
    exit 2
fi
