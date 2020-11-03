#!/bin/bash

rootDir=$(cd $(dirname $0); pwd -P)
scriptParameters=$@

function runInSubProjects() {
    local command=$@
    for project in $(getProjects)
    do
        runInProject ${project} ${command}
    done
}

function getProjects(){
    local pubSpecFiles=$(find ${rootDir} -mindepth 2 -name pubspec.yaml | sort)
    for file in ${pubSpecFiles}
    do
        local project=$(dirname ${file})
        echo ${project##./}
    done
}

function runInProject() {
    local project=$1
    shift
    local parameters=$@
    pushd ${project} > /dev/null
    ${parameters}
    popd > /dev/null
}

runInSubProjects flutter pub get
