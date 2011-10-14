# Web Sync - End-user oriented web site synchronization

This project aims at building a system for end-users to maintain a mostly static 
web site in a simple and effective way. It relies on the following agents:

* An end-user called Client, who maintains and updates the website content and
  structure so as to meet her strategic goals. The Client works on his 
  LocalMachine. She has the ability to run the website locally to maintain the 
  website in a kind of WYSIWYG environment. The LocalMachine also provides an
  interface to deploy and manage the website workflow.
* A computer scientist called Engineer maintains the overal system and provide 
  bug fixes and new features on the website and the deployment workflow.
* A web platform such as Github maintains the web site sources in a distributed 
  way.
* A production Server deploys the website on production.
* Git commands are used internally for implementing the website workflow.
* Ruby and Sinatra as web framework for the website itself.

## Environment operations

Edit
  Description: Edit, delete or add some files on the local copy
  Agent:   Client
  DomPre:  true
  DomPost: PendingChanges

FixBug
  Description: Fix a bug on the developer/github copy
  Agent:   Engineer + Git
  DomPre:  true
  DomPost: !AllBugFixesApplied

## Operational specifications

Import
  Description: Import bug-fixes and new features from Github into local version.
  DomPre:  !AllBugFixesApplied
  DomPost: AllBugFixesApplied
  ReqPre:  !PendingChanges for Avoid[GitMergesWhenPendingChanges] -> Avoid[RuntimeErrors]

Deploy
  Description: Deploys the website by applying all local savings to the production
               server
  DomPre:  !Deployed
  DomPost: Deployed
  ReqPre:  !PendingChanges    for Avoid[BadDeployFalsePositive] -> Maximize[UserIntuition]
           AllBugFixesApplied for Maintain[BugFixesDeployedEarly] -> Maximize[Security]
                                  Maintain[LinearHistory] -> Maximize[Simplicity]

Save
  Description: Save the website locally
  DomPre:  PendingChanges
  DomPost: !PendingChanges
  ReqPost: !Deployed for Avoid[AutoDeployOnSaving] -> Maximize[Flexibility]
  
## Fluent definitions

fluent AllBugFixesApplied = {Import}, {FixBug} initially True
fluent PendingChanges = {Edit}, {Save} initially False
fluent Deployed = {Deploy}, {Save} initially True

