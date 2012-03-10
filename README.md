The **Metacello Scripting API** provides a clean and simple to use api for managing software projects 
based on Metacello. 

## Phase I Introduction
The API is project-oriented. Every command starts by specifying the project details like: *name*, *version*, 
and *repository url*. The *name* is the name of the project (sans *ConfigurationOf*). The *version* 
is the version of the project and the *repository url* specifies the location of the **Metacello configuration**. 

In addition to the standard Monticello repositories used for storing binary **mcz** files. Metacello supports 
a new file system-based package format that makes it possible to include support 
for traditional **Source Code Management Systems** like Svn and Git.

Commands include the standard Metacello **load/fetch/record** commands as well as 
project life-cycle operations like **commit** and **upgrade**. 

###Commands
#### Load
The following script is used to load version **3.0.6** of the **Seaside30** project using the 
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
loads. The following script:

```Smalltalk
Metacello new
  project: 'Seaside30';
  load.
```

loads the **#stable** version of **Seaside30** using the **ConfigurationOfSeaside30** found in 
the http://www.squeaksource.com/MetacelloRepository repository.


####Commit
The **commit** command:

```Smalltalk
Metacello new
  project: 'Seaside30';
  commit: 'fix Issue 134'.
```

Performs a commit for each Monticello package in the **Seaside30** that has been modified, updates 
the specification in the configuration for **Seaside30** and commits that package as well.

#### Upgrade
The **upgrade** command:

```Smalltalk
Metacello new
  project: 'Seaside30';
  version: '3.0.6.3';
  upgrade.
```

Loads the latest version of the **ConfigurationOfSeaside30** and then loads version **3.0.6.3**. **Upgrade** 
differs from **load** in that **load** does not refresh the in-image copy of **ConfigurationOfSeaside30**. 
The distinction between **load** and **upgrade** becomes more important when working with GitHub-based projects.

###File-based Monticello Packages
The basic idea is to store individual methods in files so that git can manage method-level history. 
The split between **classes** and **extensions** in the **snapshot** directory is differentiate between 
classes defined in a package and extension methods defined in the package:

```
+-Sample-Core.pkg\
  +-snapshot\
  | +-classes\
  | | +-SampleCore.class\
  | |   +-SampleCore.st
  | |   +-instance\
  | |     +-author.st
  | +-extensions\
  |   +-Object.class\
  |     +-instance\
  |       +-isSample.st
  +-.filetree
  +-categories.st
  +-initializers.st
  +-package
  +-version
```

####FileTree Repository
The **FileTree repository** is used to access a collection of file-based Monticello packages that are 
stored in a directory on your local disk. 

Here's an example of the structure of a **FileTree repository**:

```
+-sample
  +-core/
  | +-metacello.json
  | +-Sample-Core.pkg\
  | +-Sample-Platform.gemstone.pkg\
  | +-Sample-Platform.pharo.pkg\
  | +-Sample-Platform.squeak.pkg\
  | +-Sample-Tests.pkg\
  +-doc/
  +-license.txt
  +-README.md
```

The following script:

```Smalltalk
Metacello new
    project: 'Sample';
    repository: 'filetree:///opt/git/sample/core/';
    load.
```

####GitHub Repository

```Smalltalk
Metacello new
    project: 'Sample';
    repository: 'github://dalehenrich/sample:master/core';
    get.
```
