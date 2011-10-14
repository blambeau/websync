$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'websync'
require 'fileutils'

def fixtures_folder
  File.expand_path("../fixtures", __FILE__)
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

def build_git_repo
  code = <<-EOF
    rm -rf #{git_repo_base}
    mkdir #{git_repo_base}
    #
    mkdir #{git_repo_origin}
    cd #{git_repo_origin}
    git init --bare
    #
    cd #{git_repo_client}
    git init
    echo "ignored file" > IGNORED.md
    echo "initial commit" > README.md
    echo "IGNORED.md" > .gitignore
    git add README.md .gitignore
    git commit -a -m "Initial repository layout"`
    git remote add origin #{git_repo_origin}
    git push -u origin master
  EOF
  `#{code}`
end

def reset_git_repo_client
  `cd #{git_repo_client}
   rm -rf ADDED.md
   git reset --hard`
end


