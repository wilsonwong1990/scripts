echo "What is the org/repo"
read repo

git checkout -b main
git push --set-upstream origin main
git branch -d master
sleep 15
curl -X PATCH "https://api.github.com/repos/${repo}" -H "Authorization: Bearer ${GITHUB_API_TOKEN}" -H 'Content-Type: application/json' --data-raw '{
  "default_branch": "main"
}'
git push origin --delete master
git branch
