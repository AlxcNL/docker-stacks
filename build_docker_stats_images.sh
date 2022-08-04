#!/bin/bash

owner="jaboo"

notebooks=("base-notebook" "simpylc-notebook")
version="0.5"

for notebook in "${notebooks[@]}"
do
    printf "Build docker image for %s\n" "${notebook}"
    (cd ../docker-stacks; make -e OWNER=${owner} -e NB_USER="student" build/${notebook})
    
    imageName="${owner}/${notebook}"
    imageTag="${imageName}:${version}"
    
    printf "Add tags %s and latest to %s\n" "${imageTag}" "${imageName}"
    tag_cmd1="docker tag ${imageName} ${imageTag}"
    echo ${tag_cmd1}
    eval ${tag_cmd1}

    tag_cmd2="docker tag ${imageName} latest" 
    echo ${tag_cmd2}
    eval ${tag_cmd2}

done

docker images | grep ${owner}
