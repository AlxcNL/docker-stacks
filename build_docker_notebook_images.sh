#!/bin/bash

owner="jaboo"

version="1.0-ubuntu"
rootContainer="ubuntu:22.04"

notebooks=("base-notebook" "simpylc-notebook" "miw-notebook")

for notebook in "${notebooks[@]}"
do
    printf "Use Rootcontainer : %s\n" ${rootContainer}
    printf "Build docker image for %s\n" ${notebook} 
    (cd ../docker-stacks; make -e OWNER=${owner} -e NB_USER="student" -e ROOT_CONTAINER=${rootContainer} build/${notebook})
    
    imageName="${owner}/${notebook}"
    imageTag="${imageName}:${version}"
    
    printf "Add tags %s to %s\n" "${imageTag}" "${imageName}"
    tag_cmd1="docker tag ${imageName} ${imageTag}"
    echo ${tag_cmd1}
    eval ${tag_cmd1}

    tag_cmd2="docker tag ${imageName} " 
    echo ${tag_cmd2}
    eval ${tag_cmd2}

    rootContainer="${imageTag}"

done

docker images | grep ${owner}