## Get's the content of a file from a repository and decodes it from base64
## Replace <YOUR-GHES-HOSTNAME> with your GHES hostname
echo "Is this for GHES or dotcom?"
read server_type

if [ "$server_type" = "dotcom" ]; then api_url="https://api.github.com"; fi

if [ "$server_type" = "GHES" ]; then api_url="https://<YOUR-GHES-HOSTNAME>/api/v3"; fi
echo $api_url
echo "What is the repository we want to get contents from? (in ORG/REPO format)"
read repo

branches=$(curl -X GET ${api_url}/repos/${repo}/branches -H "Authorization: Bearer ${GITHUB_API_TOKEN}")

echo $branches | jq '.[] | {name: .name, commit: .commit}'

echo "What branch are we working with?"
read branch

commit_sha=$(curl -X GET ${api_url}/repos/${repo}/git/ref/heads/${branch} -H "Authorization: Bearer ${GITHUB_API_TOKEN}" | jq -r '.object.sha')
echo ${commit_sha}

tree_sha=$(curl -X GET ${api_url}/repos/${repo}/git/commits/${commit_sha} -H "Authorization: Bearer ${GITHUB_API_TOKEN}" | jq -r '.tree.sha')

echo ${tree_sha}

tree=$(curl -X GET ${api_url}/repos/${repo}/git/trees/${tree_sha} -H "Authorization: Bearer ${GITHUB_API_TOKEN}")

echo $tree | jq

echo "What file are we looking for? Enter the SHA"
read blob_sha

blob=$(curl -X GET ${api_url}/repos/${repo}/git/blobs/${blob_sha} -H "Authorization: Bearer ${GITHUB_API_TOKEN}" | jq -r '.content')
echo $blob | base64 -d
