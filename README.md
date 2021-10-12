## CSV to M$-OFX
Just in case you never heard about OFX before  
V1 was an attempt to create a dedicated SGML for banking and ignoring XML. [Details](https://financialdataexchange.org/FDX/About/OFX-Work-Group.aspx?WebsiteKey=deae9d6d-1a7a-457b-a678-8a5517f8a474&hkey=f6ef5a03-c596-49a4-a89a-3f368e1ee43f&OFX_Work_Group_Tab=2#OFX_Work_Group_Tab).    
   
I met OFX (V1) as the import format for M$ MONEY (later Sunset) provided by my bank in the late 90ies.   
It's limited to US-ASCII without any ÄÖÜß.... and still SGML only   
A decade later my banks stopped the support of OFX and offered CSV as a replacement.   
- one of them delivered clean ASCII encoded files.   
- the other provided something UTF-16LE encoding.   
   
To stay with Sunset was the trigger to generate OFX (V1) myself and take care of transcoding.  
The result is a small Production in Interoperability/Ensemble    
  ![image](https://user-images.githubusercontent.com/31236645/136959422-28162601-fee0-4e1e-ab38-023bd2f90f36.png)    
divided into these steps:   
- an InputFileService to look for fresh files trigger a customized input by bank into a local table    
  to exclude duplicates and fix other nonsense as transcoding to pure 7bit US-ASCII or fixing odd headers   
- a BPL Business Process to trigger the correct output from the relevant table  
  ![image](https://user-images.githubusercontent.com/31236645/136959204-a95eac6d-d625-45bf-8d3a-cc91c9847e03.png)

- Business Operations to produce clean and well-formatted OFX files based on   
- a customized OFX_OutboundAdaptor parametrized by static information related to bank and account   
- a Helper to add required information not supplied by any CSV. (e.g. account balance ) ,   
 Start / Stop the production, display the generated OFX_files (especially for Docker Containers)   
 
- The final starter for MS MONEY was removed as it requires details of the working installation in Windows.

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
The input/output directories of the productin are mapped to {clonedir}\MONEY\
Subdirectory {clonedir}\MONEY\sample\ hold 2 sample CSV files for testing

Optionally you may connect using SMP to production **rcc.MONEY.Production**  
and change file locations for Servise and Operations or   
adjust BankID and AccountID required for OFX in the 2 Operations.   
You can apply the same result with less clicking it is all stores in   
**Class rcc.MONEY.Production** with the EDI of your choice.

## How to Test it
- The banks in my exampke are named AT and BW
- You can start the production directly from SMP or use 
- The Init utility to provide account ballances (not delivered by CSV)  
Open IRIS terminal:  
```
 docker-compose exec iris iris session iris
Node: 210293683a03, Instance: IRIS

USER>do ##class(rcc.MONEY).Init()

Enter Ballance AT () :7777.77
New Ballance AT = 7777.77

Enter Ballance BW () :666.66
New Ballance BW = 666.66

Start Production ? (yYnN)y

13:36:15.807:Ens.Director: Production 'rcc.MONEY.Production' starting...
13:36:15.903:Ens.Director: Production 'rcc.MONEY.Production' started.
scan output for BW
select file #:
scan output for AT
select file #:
Continue Scan? (yYnN) y
```
After starting the production you enter a lop to scan output directories.   
Now you can copy the provided samples into the production's input from
outside the container with drag an' drop
```
 {clonedir}\MONEY\sample\  >>>>  {clonedir}\MONEY\in\
```
or inside the container from bash
```
    docker-compose exec iris bash
irisowner@210293683a03:/opt/irisbuild$  ls -l /MONEY/sample/ 
total 12
-rwxrwxrwx 1 root root 4430 Oct 12 13:10 AT28A.csv
-rwxrwxrwx 1 root root 2814 Oct 12 13:10 BW__777.csv
-rwxrwxrwx 1 root root   12 Oct 12 13:10 GitHub.txt
irisowner@210293683a03:/opt/irisbuild$ cp -v /MONEY/sample/*.csv /MONEY/in/
'/MONEY/sample/AT28A.csv' -> '/MONEY/in/AT28A.csv'
'/MONEY/sample/BW_99_777.csv' -> '/MONEY/in/BW_99_777.csv'
irisowner@210293683a03:/opt/irisbuild$
```
You can also start the scan independently with a hang parameter  
```
USER>do ##class(rcc.MONEY).Wait(2)
scan output for BW
 
select file #:
 
scan output for AT
 
select file #:
  
Continue Scan? (yYnN) y

scan output for BW

1    BW_20211012_134519.OFX
select file #: 1 
```
[BW_20211012_134519.OFX](https://github.com/rcemper/CSV-to-MS-OFX/blob/master/MONEY/results/BW_sample_result.OFX)
```
scan output for AT

1    AT_20211012_134519.OFX
select file #: 1 
```
[AT_20211012_134519.OFX](https://github.com/rcemper/CSV-to-MS-OFX/blob/master/MONEY/results/AT_sample_result.OFX)
```
Continue Scan? (yYnN) y
```
Stopping the production is also included
```
USER>do ##class(rcc.MONEY).Stop()

Stop Production ? (yYnN)y

14:41:56.127:Ens.Director: StopProduction initiated.
14:41:56.134:Ens.Director: Production 'rcc.MONEY.Production' stopped.
USER>
```
[Related Article in DC](https://community.intersystems.com/post/generating-ofx-v1)
