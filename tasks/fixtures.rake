task :"fixtures:create" do
  require 'fileutils'
  require 'grit'

  # a few paths
  fixtures        = File.expand_path("../../spec/fixtures", __FILE__)
  git_repo_base   = File.join(fixtures, "gitrepo")
  git_repo_origin = File.join(git_repo_base, "origin")
  git_repo_client = File.join(git_repo_base, "client")

  # let remove everything first
  FileUtils.rm_rf git_repo_base

  # 1) build a fresh new bare repository
  FileUtils.mkdir_p git_repo_origin
  Dir.chdir(git_repo_origin) do 
    Grit::Repo::init_bare(git_repo_origin)
  end

  # 3) build the first repository layout
  FileUtils.mkdir_p git_repo_client
  Dir.chdir(git_repo_client) do 
    repo = Grit::Repo::init(git_repo_client)
    File.open("IGNORED.md", "w"){|f| f << "ignored file\n"}
    File.open("README.md", "w") {|f| f << "initial commit\n"}
    File.open(".gitignore", "w"){|f| f << "IGNORED.md\n"}
    repo.add("README.md", ".gitignore")
    repo.commit_all("Initial project layout.")
    repo.remote_add("origin", git_repo_origin)
    `cd #{git_repo_client} && git push -u origin master`
  end
end
task :test => :"fixtures:create"
