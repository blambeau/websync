require 'grit'
module WebSync
  class WorkingDir
    class Git < WorkingDir

      #################################################################### Model

      # (see WorkingDir#pending_changes)
      def pending_changes
        gritrepo.status.select{|f|
          f.type || (f.untracked && !f.ignored)
        }
      end

      # (see WorkingDir#unpulled_commits)
      def unpulled_commits
        git.rev_list(git_opts, "^master", "origin/master").
            split("\n").
            map{|id| gritrepo.commit(id)}
      end

      # (see WorkingDir#unpushed_commits)
      def unpushed_commits
        git.rev_list(git_opts, "master", "^origin/master").
            split("\n").
            map{|id| gritrepo.commit(id)}
      end

      #################################################### High-level operations

      # (see WorkingDir#save)
      def save(message)
        to_be_added = pending_changes.select{|f|
          f.untracked && f.type.nil?
        }
        git.add(git_opts, *to_be_added.map{|f| f.path})
        git.commit(git_opts(), '-a', '-m', message)
        self
      end

      # (see WorkingDir#push)
      def push(*args)
        args = ["origin"] if args.empty?
        git.push(git_opts, *args)
        self
      end

      # (see WorkingDir#pull)
      def pull(*args)
        rebase(*args)
        self
      end

      ########################################################### Git operations

      def update_info
        git.remote(git_opts.merge(:raise => false), "update")
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

      def rebase(*args)
        args = ["origin/master"] if args.empty?
        git.rebase(git_opts, *args)
        self
      end

      private 

      GIT_OPTS = {:raise => true, :timeout => false}

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
