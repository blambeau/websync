require 'grit'
module WebSync
  class WorkingDir
    class Git < WorkingDir

      GIT_OPTS = {:raise => true, :timeout => false}

      def update_info
        git.remote(git_opts.merge(:raise => false), "update")
        self
      end

      # Returns the list of pending changes on the local copy
      def pending_changes
        gritrepo.status.select{|f|
          f.type || (f.untracked && !f.ignored)
        }
      end

      # Returns the list of unpulled bugfixes
      def unpulled_commits
        git.rev_list(git_opts, "^master", "origin/master").
            split("\n").
            map{|id| gritrepo.commit(id)}
      end

      # Returns the list of unpushed commits
      def unpushed_commits
        git.rev_list(git_opts, "master", "^origin/master").
            split("\n").
            map{|id| gritrepo.commit(id)}
      end

      def save(commit_message)
        to_be_added = pending_changes.select{|f|
          f.untracked && f.type.nil?
        }
        git.add(git_opts, *to_be_added.map{|f| f.path})
        git.commit(git_opts(), '-a', '-m', commit_message)
        self
      end

      def push(*args)
        args = ["origin"] if args.empty?
        git.push(git_opts, *args)
        self
      end

      def tag(tag_name)
        git.tag(git_opts, tag_name)
        push("origin", tag_name)
        self
      end

      def reset(tag_name)
        git.reset(git_opts(:hard => true), tag_name)
        self
      end

      def rebase
        update_info
        git.rebase(git_opts, "origin/master")
        self
      end

      private 

      def gritrepo
        @gritrepo ||= Grit::Repo.new(path.to_s)
      end

      def git
        gritrepo.git
      end

      def git_opts(opts = {})
        GIT_OPTS.merge(:chdir => path.to_s).merge(opts)
      end

    end # class Git
  end # class WorkingDir
end # module WebSync
