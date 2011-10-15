task :"fixtures:create" do
  require 'fileutils'
  require 'grit'
  #Grit.git_binary = "git"
  Grit.debug = true

  # a few paths
  fixtures        = "/tmp/websync-fixtures"
  git_repo_base   = File.join(fixtures, "gitrepo")
  git_repo_origin = File.join(git_repo_base, "origin")
  git_repo_client = File.join(git_repo_base, "client")

  # let remove everything first
  FileUtils.rm_rf git_repo_base

  # 1) build a fresh new bare repository
  FileUtils.mkdir_p git_repo_origin
  Grit::Repo::init_bare(git_repo_origin)

  # 2) build the first repository layout
  FileUtils.mkdir_p git_repo_client
  Dir.chdir(git_repo_client) do
    repo = Grit::Repo::init(git_repo_client)
    File.open("IGNORED.md", "w"){|f| f << "ignored file\n"}
    File.open("README.md", "w") {|f| f << "initial commit\n"}
    File.open(".gitignore", "w"){|f| f << "IGNORED.md\n"}
    repo.add("README.md", ".gitignore")
    repo.commit_all("Initial project layout.")
    repo.remote_add("origin", git_repo_origin)
    repo.git.push({:u => true}, "origin", "master")
  end
end
task :test => :"fixtures:create"
