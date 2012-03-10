The **Metacello Scripting API** provides a clean and simple to use api for managing software projects 
based on Metacello. 

## Introduction
The API is project-oriented. Every command starts by specifying the project details like: *name*, *version*, 
and *repository url*. The *name* is the name of the project (sans *ConfigurationOf*). The *version* 
is the version of the project and the *repository url* specifies the location of the **Metacello configuration**. 

###Commands

Commands include the standard Metacello *load/fetch/record* commands as well as 
project life-cycle operations like **commit** and **upgrade**. 

#### Load
The following command is used to load version **3.0.6** of the **Seaside30** project using the 
**ConfigurationOfSeaside30** found in the **http://www.squeaksource.com/Seaside30/** repository:

```Smalltalk
Metacello new
  project: 'Seaside30';
  version: '3.0.6';
  repository: 'http://www.squeaksource.com/Seaside30/';
  load.
```

The **Metacello Scripting API** includes a built-in configuration search path 
(http://www.squeaksource.com/MetacelloRepository/ by default) and default versions (#'stable' by default) for 
loads. The following expression:

```Smalltalk
Metacello new
  project: 'Seaside30';
  load.
```

loads the **#stable** version of Seaside30 using the **ConfigurationOfSeaside30** found in 
the http://www.squeaksource.com/MetacelloRepository repository.


####Commit
The **commit** command:

```Smalltalk
Metacello new
  project: 'Seaside30';
  commit: 'fix Issue 134'.
```

Performs a commit for each Monticello package in the *Seaside30* that has been modified, updates 
the specification in the configuration for *Seaside30* and commits that package as well.

#### Upgrade
The **upgrade** command:

```Smalltalk
Metacello new
  project: 'Seaside30';
  version: '3.0.6.3';
  upgrade.
```

Loads the latest version of the ConfigurationOfSeaside30 and then loads version '3.0.6.3'. **Upgrade** 
differs from **load** in that **load** does not refresh the in-image copy of ConfigurationOfSeaside30. 
The distinction between **load** and **upgrade** becomes more important when working with GitHub-based projects.

###Directory-based Monticello packages
Storing binary **mcz** does not make very effective use of of file system-based SCMs (like SVN and GIT).
In order to make effective use of these SCMs, it is necessary to store 
source code as text files. 

#####FileTree Repository
#####GitHub Repository

