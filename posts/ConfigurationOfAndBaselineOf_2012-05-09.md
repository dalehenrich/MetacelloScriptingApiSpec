I've spent the last month or so (outside of working on GemStone-specific things) taking a close look at the future of the ConfigurationOf in the face of git/github. 

I've created a representative sample (non-functional) of my current thinking with two configuration classes: ConfigurationOfExternal and BaselineOfExternal. Take a look at the classes if you want to see what I am thinking and it would probably help if you looked at the samples a little bit before reading further.

```Smalltalk
  Gofer new
    url: 'http://ss3.gemstone.com/ss/external';
    package: 'ConfigurationOfExternal';
    package: 'BaselineOfExternal';
    load.
```

Disk-based SCMs pose a slightly different set of problems for those of us used to working with Monticello. I've spent some time working on projects using FileTree and Git/Github trying out different development scenarios, project structures and branching schemes in an effort to figure out what role Metacello needs to play in the git/github world.

In the beginning I thought that all I needed to do was to "preserve the baseline" and git/github would take care of the rest...

The baseline specifies the package/project dependencies and that functionality is obviously still needed. I figured that we could specify the baseline in a BaselineOf class (earlier I used the name VersionOf) similar to the ConfigurationOf class, but with only one baseline method (see BaselineOfExternal>>baseline: for details).

Git manages versions of projects and you can identify 'versions' in three different ways:

* SHA or commit id: '1d4c88c2095c0d73e01a9f90fe24a3ececd9bd84'
* tag name: '1.0'
* branch name: 'master'

I figured all we had to do was use the 'git version' in place of the Metacello versionString and we'd be off to the races:

```Smalltalk
   spec
        project: 'Grease'
        with: [ 
            spec
                versionString: '1d4c88c2095c0d73e01a9f90fe24a3ececd9bd84';
                loads: #('Core');
                repository: 'github://seaside/Grease/repository' ]
```

When Metacello loads version '1d4c88c2095c0d73e01a9f90fe24a3ececd9bd84' in the 'github://seaside/Grease/repository', it looks for the BaselineOfGrease configuration instead of ConfigurationOfGrease. Cool, huh?

There are a large number of use cases where this approach will work just fine, but unfortunately this approach doesn't work for all use cases. 

Using an explicit 'git version' suffers from the same problems that symbolic versions were invented to solve, i.e.:

```
  When the correct version to be loaded is a function of the 
  platform into which the project is being loaded.
```

So after much teeth gnashing and hair pulling, I have conceded that I can't completely get rid of the ConfigurationOf...

Of course, there are plenty of good reasons for keeping the ConfigurationOf with or without symbolic versions:

* MetacelloRepository would continue to be a good place to 
    find configurations
* existing projects can move development to git/github 
    and users won't have to switch to a new scheme for loading
* folks have invested time into documenting/understanding 
    Metacello configurations and that time is not lost

So in the new scheme, when you publish a version that is stored on github, this is what the spec will look like:

```Smalltalk
  version20: spec
    <version: '2.0' baselineOf: 'External'>
    spec
        for: #'common'
        do: [ 
            spec blessing: #'release'.
            spec
                version: '957492f31b77026d81dcb165c07c69b2ad897781';
                repository: 'github://dalehenrich/external/repository';
                yourself ]
```

and just for Doru, here's how you would specify a bleeding edge version:

```Smalltalk
  default: spec
    <version: 'default' baselineOf: 'External'>
    spec
        for: #'common'
        do: [ 
            spec blessing: #'development'.
            spec
                version: 'master';
                repository: 'github://dalehenrich/external/repository';
                yourself ]
```

where 'master' is the name of a branch. When a branch name is specified the HEAD of the branch is loaded and you'll always get the latest working version loaded.

Modulo a couple of tweaks I have working code in Metacello that supports this model and using the Metacello Scripting API the following load expressions work:

```Smalltalk
    "load version 1.0 of the External project using the ConfigurationOfExternal
        from  http://ss3.gemstone.com/ss/external
        packages in .mcz repo"
    Metacello new
        project: 'External';
        version: '1.0';
        repository: 'http://ss3.gemstone.com/ss/external';
        load.
    "load version 2.0 of the External project using the ConfigurationOfExternal 
        from  http://ss3.gemstone.com/ss/external
        packages in github repo"
    Metacello new
        project: 'External';
        version: '2.0';
        repository: 'http://ss3.gemstone.com/ss/external';
        load.
    "load the External project using the BaselineOfExternal
        from  github://dalehenrich/external/repository
        packages in github repo"
    Metacello new
        project: 'External';
        version: '957492f31b77026d81dcb165c07c69b2ad897781';
        repository: 'github://dalehenrich/external/repository';
        load.
```

So, I'm getting close and I'd specifically like some feedback on the BaselineOf and <version:baselineOf pragma ideas, since these are the new specification features that are needed for support of git/github repositories.

