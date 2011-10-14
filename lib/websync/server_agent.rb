module WebSync
  class ServerAgent

    # Is the production up to date?
    def production_up_to_date?
    end

    #
    # Synchronize the production server from the Repository
    #
    # DomPre  
    #   not(production_up_to_date?)
    # DomPost
    #   production_up_to_date!
    # RegTrig for Achieve[WebSite UpToDate When RepoSync Notified]
    #   repo_sync_notified
    #
    def synchronize
    end

  end # class ServerAgent
end # class WebSync
