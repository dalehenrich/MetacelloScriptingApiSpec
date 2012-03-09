The **Metacello Scripting API** provides a clean and simple to use api for managing software projects based on Metacello. 

### Introduction
The API is project-oriented. Every command starts by specifying the project details like: *name*, *version*, and *repository url*. The  *repository url* specifies the location of the **Metacello configuration** to be used for the requested operation. Operations include the standard Metacello *load/fetch/record* commands as well as other commands that will be covered later.
#### Load
The following command is used to load version **#stable** of the **Seaside30** project using the **ConfigurationOfSeaside30** found in the **http://www.squeaksource.com/Seaside30/** repository:

```Smalltalk
Metacello new
  project: 'Seaside30';
  version: #'stable';
  repository: 'http://www.squeaksource.com/Seaside30/';
  load.
```

The **Metacello Scripting API** includes a built-in configuration search path ( http://www.squeaksource.com/MetacelloRepository/ by default) and default versions for loads, so that the above expression can be reduced to:

```Smalltalk
Metacello new
  project: 'Seaside30';
  load.
```

The **Metacello Scripting API** has support for project life-cycle operations like **commit** and **upgrade**. 

####Commit
The **commit** command:

```Smalltalk
Metacello new
  project: 'Seaside30';
  commit: 'fix Issue 134'.
```

Performs a commit for each Monticello package in the *Seaside30* that has been modified, updates the specification in the configuration for *Seaside30* and commits that package as well.

#### Upgrade
The **upgrade** command:

```Smalltalk
Metacello new
  project: 'Seaside30';
  version: '3.0.6.3';
  upgrade.
```

Loads the latest version of the ConfigurationOfSeaside30 and then loads version '3.0.6.3'. **Upgrade** differs from **load** in that **load** does not refresh the in-image copy of ConfigurationOfSeaside30. The distinction between **load** and **upgrade** becomes more important when working with GitHub-based projects.
