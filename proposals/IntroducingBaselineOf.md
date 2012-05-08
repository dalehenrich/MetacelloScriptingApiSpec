#Introducing BaselineOf in support of GitHub

##Old-style configuration

###ConfigurationOfExternal

####baseline10:

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

####version10:

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

##New-style configuration

###BaselineOfExternal

####baseline:

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

###ConfigurationOfExternal

####version10:

```Smalltalk
version10: spec
    <version: '0.9' baselineOf: 'External'>
    spec
        for: #'common'
        do: [ 
            spec blessing: #'release'.
            spec
                repository: 'github://dalehenrich/external/repository';
                repositoryVersion: '957492f31b77026d81dcb165c07c69b2ad897781' ]
```

