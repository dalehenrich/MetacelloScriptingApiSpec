#Converting ConfigurationOf to a ConfigurationOf and BaselineOf for a GitHub project

In order to manage a disk-based repository with Metacello, we must split the classic ConfigurationOf into two pieces: a ConfigurationOf and a BaselineOf.

The BaselineOf simply consists of a baseline version which describes the structure of the project:

  * package and external project dependencies
  * groups

The ConfigurationOf defines project versions and defers to the BaselineOf for project structure.

##Project particulars

For this exercise we'll look at version 1.0 of the External project with two packages:

  * External-Core-dkh.5
  * External-Tests-dkh.2

####1.0-baseline
Here's the baseline specification for 1.0-baseline:

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

####1.0
Here's the version specification for 1.0:

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

##Create git repository
##Set up FileTree repository
##Copy packages to FileTree repository
##Create BaselineOfExternal

To create the BaselineOf we first create the class as a subclass of **MetacelloBaseBaselineConfiguration** (yes, we'll assume that this class exists in the base image of all platforms). 
Then we add the **baseline:** method:

* copy the [**baseline10:**](#10-baseline) method
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

##Save BaselineOfExternal in FileTree repository
##Push to GitHub
##Modify ConfigurationOfExternal

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

##Save ConfigurationOfExternal
