  "download HEAD of master branch of the sample project, i.e., download from github, but don't load Sample project into image"
  Metacello new
    project: 'Sample';
    repository: 'github://dalehenrich/sample:master/core';
    get.

  "load HEAD of master branch of the sample project, i.e., download from github, and load Sample project into image"
  Metacello new
    project: 'Sample';
    repository: 'github://dalehenrich/sample:master/core';
    load.

  "load HEAD of master branch of the external project, i.e., download from github, and load Sample project into image"
  Metacello new
    project: 'External';
    repository: 'github://dalehenrich/external:master/core';
    load.

"-----------------------------------------------------------------------------------------"

  "load HEAD of master branch of the sample project, from cloned /opt/git/sample git repository"
  Metacello new
    project: 'Sample';
    repository: 'filetree:///opt/git/sample/core/';
    load.

  "load HEAD of master branch of the external project, from cloned /opt/git/external git repository"
  Metacello new
    project: 'External';
    repository: 'filetree:///opt/git/external/core/';
    load.

"-----------------------------------------------------------------------------------------"


