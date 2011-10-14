module WebSync
  class ClientAgent

    ############################################################ State Variables

    # Is there pending changes on the local copy?
    def pending_changes?
    end

    # Is there bug fixes availables for the local copy?
    def bug_fixes_available?
    end

    # Does the local copy have local savings?
    def local_savings?
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
    end

    #
    # Save the pending changes of the local version
    #
    # DomPre
    #   pending_changes?
    # DomPost
    #   pending_changes!(false)
    # ReqPost for Avoid[AutoDeployOnSaving]
    #   has_local_savings!
    # 
    def save
    end

    #
    # Synchronize the repository with saved local changes
    #
    # DomPre
    #   local_savings?
    # DomPost
    #   has_local_savings!(false)
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
    #   @not(local_savings?)
    #
    def notify_repo_synced
    end

  end # class ClientAgent
end # end WebSync
