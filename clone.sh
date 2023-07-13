#!/bin/bash
ACCOUNT_ID=$1
REGION=$2
REPOLIST=$3
echo "- Cloning the following Docker Hub repositories for account ${ACCOUNT_ID} in region ${REGION}: ${REPOLIST}"
for repo in $(echo ${REPOLIST} | sed "s/,/ /g")
do
  echo " ***** ${repo}"
  docker pull docker.io/${repo}
done
echo "- Done pulling, I have these images now"
docker images
echo "- Will now login to ECR"
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
echo "- Will now tag and push the images to ECR"
for repo in $(echo ${REPOLIST} | sed "s/,/ /g")
do
  echo " ***** ${repo}"
  docker tag ${repo} $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/${repo}
  docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/${repo}
done
echo "- Done pushing to ECR"