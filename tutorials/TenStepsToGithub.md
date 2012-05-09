#10 Steps from *.mcz* to GitHub
In this tutorial we'll go over the steps necessary to convert an
*.mcz-based* project into a *git/github-based* project.

##Introduction
In order to manage a disk-based repository with Metacello, it is necessary to split the classic ConfigurationOf into two pieces: a ConfigurationOf and a BaselineOf.

The BaselineOf consists of a baseline version which describes the structure of the project:

  * package and external project dependencies
  * groups

##10 Steps
1. [Example Project](#1-example-project)
2. [Create git repository](#2-create-git-repository)
3. [Install FileTree](#3-install-filetree)
4. [Copy packages to *external*](#4-copy-packages-to-external)
5. [Create BaselineOfExternal](#5-create-baselineofexternal)
6. [Save BaselineOfExternl](#6-save-baselineofexternal)
7. [Push to Github](#7-push-to-github)
8. [Modify ConfigurationOfExternal](#8-modify-configurationofexternal)
9. [Save ConfigurationOfExternal](#9-save-configurationofexternal)
10. **????**

##1. Example Project
Load an existing *.mcz-based* project into your image:

```Smalltalk
Gofer new
  ss3: 'External';
  package: 'ConfigurationOfExternal';
  load.
((Smalltalk at: #ConfigurationOfExternal) project version: '1.0') load: 'ALL'`
```

This project has two packages:

  * External-Core-dkh.5
  * External-Tests-dkh.2

####Version 1.0-baseline

```Smalltalk
baseline10: spec
    <version: '1.0-baseline'>
    spec
        for: #'common'
        do: [ 
            spec blessing: #'baseline'.
            spec
                package: 'External-Core';
                package: 'External-Tests' with: [ spec requires: 'External-Core' ];
                yourself.
            spec
                group: 'Core' with: #('External-Core');
                group: 'default' with: #('Core');
                group: 'Tests' with: #('External-Tests');
                yourself ]
```

####Version 1.0

```Smalltalk
version10: spec
    <version: '1.0' imports: #('1.0-baseline')>
    spec
        for: #'common'
        do: [ 
            spec blessing: #'release'.
            spec
                package: 'External-Core' with: 'External-Core-dkh.5';
                package: 'External-Tests' with: 'External-Tests-dkh.2';
                yourself ]
```

##2. Create git repository

```shell
mkdir /opt/git/external
cd /opt/git/external
git init
```

##3. Install FileTree repository
Follow the [FileTree installation instructions](https://github.com/dalehenrich/filetree/blob/master/README.md).
##4. Copy packages to FileTree repository

```Smalltalk
| externalRepo sourceRepo versionInfo |
externalRepo := MCFileTreeRepository new directory: (FileDirectory on: '/opt/git/external').
sourceRepo := MCHttpRepository location: 'http://ss3.gemstone.com/ss/external' user: '' password: ''.

"Copy External-Core package"
versionInfo := sourceRepo versionInfoFromVersionNamed: 'External-Core-dkh.5'.
externalRepo storeVersion: (sourceRepo versionWithInfo: versionInfo ifAbsent: [ self error: 'trouble' ]).

"Copy External-Tests package"
versionInfo := sourceRepo versionInfoFromVersionNamed: 'External-Tests-dkh.2'.
externalRepo storeVersion: (sourceRepo versionWithInfo: versionInfo ifAbsent: [ self error: 'trouble' ]).
```

##5. Create BaselineOfExternal

```Smalltalk
MetacelloBaseBaselineConfiguration subclass: #BaselineOfExternal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'BaselineOfExternal'
```
 
Then we add the **baseline:** method:

* copy and paste the [**baseline10:**](#10-baseline) method
* change the selector to **baseline:**
* change the pragma to **<baseline>**

```Smalltalk
baseline: spec
    <baseline>
    spec
        for: #'common'
        do: [ 
            spec
                package: 'External-Core';
                package: 'External-Tests' with: [ spec requires: 'External-Core' ];
                yourself.
            spec
                group: 'Core' with: #('External-Core');
                group: 'default' with: #('Core');
                group: 'Tests' with: #('External-Tests');
                yourself ]
```

##6. Save BaselineOfExternal in FileTree repository
##7. Push to GitHub
##8. Modify ConfigurationOfExternal

delete baseline method
edit version10: method:

####version10:

```Smalltalk
version10: spec
    <version: '1.0' baselineOf: 'External'>
    spec
        for: #'common'
        do: [ 
            spec blessing: #'release'.
            spec
                repository: 'github://dalehenrich/external/repository';
                repositoryVersion: '957492f31b77026d81dcb165c07c69b2ad897781' ]
```

##9. Save ConfigurationOfExternal
