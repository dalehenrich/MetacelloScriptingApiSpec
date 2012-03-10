## Introduction
The **Metacello Scripting API** is project-oriented. Every command starts by specifying the project details like: *name*, 
*version*, 
and *repository url*. The *name* is the name of the project sans *ConfigurationOf*. The *version* 
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
stored in a directory on your local disk. The **FileTree repository** is neutral when it comes to which SCM is used
to manage the directory (if any at all). 

Svn, Git, or Mercurial can be used to version the contents of the 
**FileTree repository** along with any other file-based artifacts that you may want to associate with the code in the
repository.

Here's an example of the structure of a **FileTree repository** (sample/core) with multiple packages (**.pkg** directories):

```
+-sample
  +-core/
  | +-metacello.json
  | +-Sample-Core.pkg\
  | +-Sample-Platform.gemstone.pkg\
  | +-Sample-Platform.pharo.pkg\
  | +-Sample-Platform.squeak.pkg\
  | +-Sample-Tests.pkg\
  | +-VersionOfSample.pkg\
  +-doc/
  +-license.txt
  +-README.md
```

The **metacello.json** file contains the Metacello dependency information in JSON format:

```
{"baseline" : [ 
      {"common" : 
          [ 
          {"githubs" : [ 
              { "External" : { 
                  "repositories" : [ "github://dalehenrich/external/core"]}}]},
          {"packages" : [ 
              { "Sample-Core" : { 
                  "requires" : ["External"],
                  "includes" : ["Sample-Platform"]}},
              { "Sample-Platform" : { 
                  "requires" : ["Sample-Core"]}},
              { "Sample-Tests" : { 
                  "requires" : ["Sample-Core"]}}]}]},
      {"gemstone" : 
          [ 
          {"packages" : [ 
              { Sample-Platform" : { 
                  "file" : "Sample-Platform.gemstone"}}]}]},
      {"pharo" : 
          [ 
          {"packages" : [ 
              { "Sample-Platform" : { 
                  "file" : "Sample-Platform.pharo"}}]}]},
      {"squeak" : 
          [ 
          {"packages" : [ 
              { "Sample-Platform" : { 
                  "file" : "Sample-Platform.squeak"}}]}]}
  ]}
```
The **baseline** version in **VersionOfSample** looks like the following:

```
    spec
        for: #'common'
        do: [ 
            spec
                github: 'External'
                with: [ 
                    spec repository: 'github://dalehenrich/external/core' ].
            spec
                package: 'Sample-Core' with: [ 
                    spec
                        requires: 'External';
                        includes: 'Sample-Platform' ]; 
                package: 'Sample-Platform' with: [ spec requires: 'Sample-Core' ];
                package: 'Sample-Tests' with: [ spec requires: 'Sample-Core' ] ].
    spec
        for: #'gemstone'
        do: [ 
            spec package: 'Sample-Platform' with: [ spec file: 'Sample-Platform.gemstone' ] ].
    spec
        for: #'pharo'
        do: [ 
            spec package: 'Sample-Platform' with: [ spec file: 'Sample-Platform.pharo' ] ].
    spec
        for: #'squeak'
        do: [ 
            spec package: 'Sample-Platform' with: [ spec file: 'Sample-Platform.squeak' ] ].
```

and was used to produce the **metacello.json** file.

The following script:

```Smalltalk
Metacello new
    project: 'Sample';
    repository: 'filetree:///opt/git/sample/core/';
    load.
```

loads the **Sample** project from the **/opt/git/sample/core/** directory.

####GitHub Repository

The following script:

```Smalltalk
Metacello new
    project: 'Sample';
    repository: 'github://dalehenrich/sample:master/core';
    get.
```

loads the **Sample** project from the **master** branch of the **https://github.com/dalehenrich/sample** project on GitHub.

#####GitHub repository description syntax

The repository description for a GitHub reference has 5 parts, as follows:

```
  github:// <github user> / <github project>  [ : <version identifier> ] [ / <repository path> ]
```

**github://** is the schema identifier for the GitHub repository description.

**github user** is the user name or organization name of the owner of the GitHub proejct.

**github project** is the name of the GitHub project.

**version identifier** is the name of a *branch*, the name of a *tag* or the *SHA* of a commit. The *tag name* and *SHA*  
identifies a specific commit. The *branch name* resolves to the current HEAD of the branch. The **version identifier** is 
optional. 

**repository path** is the path to a subdirectory in the project where the repository is rooted. If absent the repository 
is rooted in the projects HOME directory.


###Git Repository
A git-based repository is planned for Phase 3 of the project.