$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'websync'
require 'fileutils'

def fixtures_folder
  "/tmp/websync-fixtures"
end

###

def git_repo_base
  File.join(fixtures_folder, "gitrepo")
end

def git_repo_origin
  File.join(git_repo_base, "origin")
end

def git_repo_client
  File.join(git_repo_base, "client")
end

###

def reset_git_repo_client
  `cd #{git_repo_client}
   rm -rf ADDED.md
   git reset --hard origin/master`
end
