#!/bin/bash

owner="jaboo"

version="1.0-debian"
rootContainer="jlesage/baseimage:debian-11-v2.4.6"
notebooks=("base-notebook" "simpylc-notebook")

for notebook in "${notebooks[@]}"
do
    printf "Use Rootcontainer : %s\n" ${rootContainer}
    printf "Build docker image for %s\n" ${notebook} 
    (cd ../docker-stacks; make -e OWNER=${owner} -e NB_USER="student" -e ROOT_CONTAINER=${rootContainer} build/${notebook})
    
    imageName="${owner}/${notebook}"
    imageTag="${imageName}:${version}"
    
    printf "Add tags %s and debian to %s\n" "${imageTag}" "${imageName}"
    tag_cmd1="docker tag ${imageName} ${imageTag}"
    echo ${tag_cmd1}
    eval ${tag_cmd1}

    tag_cmd2="docker tag ${imageName} debian" 
    echo ${tag_cmd2}
    eval ${tag_cmd2}

    rootContainer="${imageTag}"

done

docker images | grep ${owner}
