# Web Sync - End-user oriented web site synchronization

This project aims at building a system for end-users to maintain and deploy a 
(simple) web site in a friendly and effective way. It relies on the following 
agents:

* An end-user called Client, who maintains and updates the website content and
  its structure so as to meet her strategic goals. The Client works on his 
  LocalMachine. She has the ability to run the website locally, in order to 
  work on the website in a kind of WYSIWYG environment. The LocalMachine also 
  provides an interface to manage the website workflow, such as deploying a new
  version.
* The Client is helped by an Engineer who maintains the overal system, provides
  bug fixes and new features on the website, and provides support for the 
  deployment workflow.
* A production Server runs the website in production.
* A source code Repository is also used to keep the website code. Both the 
  Client and the Engineer pull/push changes to/from this common repository. The
  production Server is also kept up-to-date with the Repository. A platform such
  as Git+Github typically provides a legacy implementation for this agent. 
* A dedicated framework, such as Rails or Sinatra, implements the website itself.
