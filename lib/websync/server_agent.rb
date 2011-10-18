module WebSync
  class ServerAgent < Agent

    # The working dir on which this client agent works
    attr_reader :working_dir

    # Creates an agent instance
    def initialize(working_dir = nil)
      @working_dir = WorkingDir.coerce(working_dir)
    end

    # Is there pending changes on the working copy?
    def pending_changes?
      working_dir.has_pending_changes?
    end

    # Is the production up to date?
    def production_up_to_date?
      working_dir.update_info
      not(working_dir.has_available_bug_fixes?)
    end

    #
    # Synchronize the production server from the Repository
    #
    # DomPre  
    #   not(production_up_to_date?)
    # DomPost
    #   production_up_to_date?
    # ReqPre for Maintain[Clean Production WorkingDir]
    #   not(pending_changes?)
    # RegTrig for Achieve[WebSite UpToDate When RepoSync Notified]
    #   repo_sync_notified
    #
    def synchronize
      req_pre!(:synchronize, :pending_changes?, false) {
        raise Error, "Unable to synchronize a dirty working dir"
      }
      if production_up_to_date?
        false
      else
        working_dir.rebase
        dom_post!(:synchronize, :production_up_to_date?, true)
        signal(:production_up_to_date)
        true
      end
    end

  end # class ServerAgent
end # class WebSync
