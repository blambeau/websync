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

      ######################################################## Search operations
    
      GREP_OPTIONS = {
        :raise => false,
        :line_number => true
      }

      # Looks for content in the working directory
      def grep(what, options = {})
        options = GREP_OPTIONS.merge(options)
        git.grep(git_opts.merge(options), what).
            split("\n").
            map{|line|
          file, line, *others = line.split(':')
          {:file => file, :line => line, :text => others.join(':')}
        }
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

      # Updates local information about the remotes (including origin)
      def update_info
        git.remote(git_opts.merge(:raise => false), "update")
        self
      end

      # Creates a tag named `tag_name` and pushes it at the origin
      def tag(tag_name)
        git.tag(git_opts, tag_name)
        push("origin", tag_name)
        self
      end

      # Resets the current repository to a given tag name
      def reset(tag_name)
        git.reset(git_opts(:hard => true), tag_name)
        self
      end

      # Rebase the working dir somewhere ("origin/master" by default)
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
