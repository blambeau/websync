module WebSync
  class ClientAgent < Agent

    # The working dir on which this client agent works
    attr_reader :working_dir

    # Creates an agent instance
    def initialize(working_dir = nil)
      if working_dir.respond_to?(:to_str)
        working_dir = WorkingDir::Git.new(working_dir)
      end
      @working_dir = working_dir
    end

    ############################################################ State Variables

    # Is there pending changes on the working copy?
    def pending_changes?
      working_dir.has_pending_changes?
    end

    # Is there bug fixes availables for the working copy?
    def bug_fixes_available?
      working_dir.has_available_bug_fixes?
    end

    # Does the local copy have local savings?
    def unpushed_commits?
      working_dir.has_unpushed_commits?
    end

    ############################################################ Operations

    #
    # Synchronize the local copy with bug-fixes and new features available in 
    # the repository.
    #
    # Return true if something has been done, false otherwise. This provides
    # simple feedback on the DomPre.
    #
    # Operationalizes
    #   Achieve[Repository BugFixes Applied To LocalCopy]
    # DomPre
    #   bug_fixes_available?
    # DomPost
    #   not(bug_fixes_available?)
    # ReqPre for Avoid[GitMergesWhenPendingChanges]
    #   not(pending_changes?)
    #
    def sync_local
      req_pre!(:sync_local, :pending_changes?, false) {
        raise Error, "Unable to synchronize a dirty working dir (save first)"
      }
      if bug_fixes_available?
        working_dir.rebase
        dom_post!(:sync_local, :bug_fixes_available?, false)
        signal(:working_dir_synchronized)
        true
      else
        false
      end
    end

    #
    # Save the pending changes of the local version
    #
    # Return true if something has been done, false otherwise. This provides
    # simple feedback on the DomPre.
    #
    # DomPre
    #   pending_changes?
    # DomPost
    #   not(pending_changes?)
    # ReqPost for Avoid[AutoDeployOnSaving]
    #   unpushed_commits?
    # 
    def save(commit_message)
      if pending_changes?
        working_dir.save(commit_message)
        dom_post!(:save, :pending_changes?, false)
        req_post!(:save, :unpushed_commits?, true)
        signal(:working_dir_saved)
        true
      else
        false
      end
    end

    #
    # Synchronize the repository with saved local changes
    #
    # DomPre
    #   unpushed_commits?
    # DomPost
    #   not(unpushed_commits?)
    # ReqPre for Avoid[BadDeployFalsePositive]
    #   not(pending_changes?)
    # ReqPre for Maintain[BugFixesDeployedEarly] & Maintain[LinearHistory]
    #   not(bug_fixes_available?)
    # ReqTrig for Achieve[Repository Synchronized When SynRequest Made]
    #   sync_repo_requested
    # ReqTrig for Maintain[Repo Synchronized If No PendingChanges and No BugFix Available]
    #   not(pending_changes?) and not(bug_fixes_available?)
    #
    def sync_repo
      req_pre!(:sync_repo, :pending_changes?, false) {
        raise Error, "Unable to syncrhonize the repository; save pending changes first."
      }
      req_pre!(:sync_repo, :bug_fixes_available?, false) {
        raise Error, "Unable to syncrhonize the repository; import bug fixes first."
      }
      if unpushed_commits?
        working_dir.push_origin
        dom_post!(:sync_repo, :pending_changes?, false)
        dom_post!(:sync_repo, :bug_fixes_available?, false)
        signal(:repository_synchronized)
        true
      else
        false
      end
    end
    upon(:user, :sync_repo_requested){ sync_repo }

  end # class ClientAgent
end # end WebSync
