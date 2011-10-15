module WebSync
  class ClientAgent

    # The working dir on which this client agent works
    attr_reader :working_dir

    # Creates an agent instance
    def initialize(working_dir)
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
    # Operationalizes
    #   Achieve[Repository BugFixes Applied To LocalCopy]
    # DomPre
    #   bug_fixes_available?
    # DomPost
    #   bug_fixes_available!(false)
    # ReqPre for Avoid[GitMergesWhenPendingChanges]
    #   not(has_pending_changes?)
    #
    def sync_local
      if pending_changes?
        raise Error, "Unable to synchronize a dirty working dir (save first)"
      end
      working_dir.rebase
      if bug_fixes_available?
        raise AssertError, "DomPost: not(bug_fixes_available?) expected"
      end
    end

    #
    # Save the pending changes of the local version
    #
    # DomPre
    #   pending_changes?
    # DomPost
    #   pending_changes!(false)
    # ReqPost for Avoid[AutoDeployOnSaving]
    #   unpushed_commits!
    # 
    def save(commit_message)
      return unless pending_changes?
      working_dir.save(commit_message)
      unless unpushed_commits?
        raise AssertError, "DomPost: unpushed_commits? expected"
      end
    end

    #
    # Synchronize the repository with saved local changes
    #
    # DomPre
    #   unpushed_commits?
    # DomPost
    #   unpushed_commits!(false)
    # ReqPre for Avoid[BadDeployFalsePositive]
    #   not(has_pending_changes?)
    # ReqPre for Maintain[BugFixesDeployedEarly] & Maintain[LinearHistory]
    #   not(bug_fixes_available?)
    # ReqTrig for Achieve[Repository Synchronized When SynRequest Made]
    #   sync_repo_requested
    # ReqTrig for Maintain[Repo Synchronized If No PendingChanges and No BugFix Available]
    #   not(has_pending_changes?) and not(bug_fixes_available?)
    #
    def sync_repo
    end

    #
    # Send a notification to the Server that the repository has been updated.
    #
    # RegTrig for Achieve[RepoSync Notified When Repo Synchronized]
    #   @not(unpushed_commits?)
    #
    def notify_repo_synced
    end

  end # class ClientAgent
end # end WebSync
