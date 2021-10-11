## CSV to MS-OFX


## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.
## Installation 
Clone/git pull the repo into any local directory
```
 git clone https://github.com/rcemper/CSV-to-MS-OFX.git
```
Open the terminal in this directory and run:
```
 docker-compose up -d --build
```
## How to Test it

Open IRIS terminal:

```
$ docker-compose exec iris iris session iris
USER>write ##class(dc.PackageSample.ObjectScript).Test()
```
## How to start 


