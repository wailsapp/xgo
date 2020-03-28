# Description

Cross compilation docker image for Wails.

It is a multi-stage Dockerfile intended to build a Docker image
capable of compiling for the following platforms:

Linux
 - arm5: linux/arm, linux/arm-5 (broken)
 - arm6: linux/arm-6            (broken)
 - arm7: linux/arm-7

Mac OS X (Darwin)
 - 386:   darwin/386   (please don't use)
 - amd64: darwin/amd64

Windows
 - 386:    windows/i386
 - amd64:  windows/amd64


## Building the image

    docker build -t xgo:wails .

## Running

  Accepts the same arguments as the original *xgo*:

    xgo -v -image xgo:wails -targets=linux/arm-7 ./
