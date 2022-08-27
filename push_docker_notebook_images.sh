#!/bin/bash

owner="jaboo"
version="1.0-ubuntu"
notebooks=("base-notebook" "simpylc-notebook" "miw-notebook")

for notebook in "${notebooks[@]}"
do
    printf "Push docker image for %s\n" ${notebook} 
    
    imageName="${owner}/${notebook}"
    imageTag="${imageName}:${version}"

    printf "Push image %s\n" "${imageTag}"
    docker push ${imageTag}    

done

docker images | grep ${owner}