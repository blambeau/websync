var websync;
websync = {

  start: function(prefix, admin) {
    $("head").append('<link rel="stylesheet" href="' + prefix + 'css/websync-admin.css" />');
    $("#say a").click(function() {
      $("#say").fadeOut();
      return false;
    });
    $.get(prefix + "view/topbar", function(data){
      $("body").prepend(data);
      $("#local-website-link").attr('href', "/")
      $("#websync-admin-link").attr("href", prefix);
    });
    if (admin) { this.ui.refresh("changes"); }
  },

  serverCall: function(action, actionData, callback) {
    $.ajax({
      type: 'POST',
      url: "user-request/" + action,
      data: actionData,
      statusCode: {
        400: function(data) {
          callback({result:  "warning", 
                    message: data.responseText});
        },
        404: function(data) {
          callback({result:  "error", 
                    message: "Action " + action + " failed (404 not found)"});
        },
        500: function(data) {
          callback({result:  "error", 
                    message: data.responseText});
        }
      },
      success: function(data) {
        callback({result:  "success", 
                  message: "Operation successful!"});
      },
      failure: function(data) {
        callback({result:  "error", 
                  message: data.responseText});
      }
    });
  },

  import: function(callback) {
    this.serverCall("import", {}, callback);
  },

  save: function(data, callback) {
    this.serverCall("save", data, callback);
  },

  deploy: function(callback) {
    this.serverCall("deploy", {}, callback);
  },

  /*
   * Set of function for handling the UI
   */
  ui: {

    say: function(data) {
      $("#say p").html(data.message);
      $("#say").attr("class", "alert-message " + data.msgType);
      if (data.msgType == "error"){
        $("#say").slideDown();
      } else {
        $("#say").slideDown().delay("1000").fadeOut();
      }
    },

    say_error: function(message) {
      this.say({message: message, msgType: "error"});
    },

    // Toggle the visibility of the `sel` element
    toggleContent: function(sel) {
      $("#" + sel + " .content").slideToggle();
      $("body").scrollTo("#" + sel, 800, {offset: {top: -40}});
    },

    // Refreshes a view
    refresh: function(view) {
      $("#" + view).fadeOut();
      $.ajax({
        type: "GET",
        url: "view/" + view,
        success: function(res) {
          $("#" + view).html(res);
          $("#" + view).fadeIn();
        },
        error: function(data) {
          msg = "<p class='feedback error'>Sorry something goes wrong here.</p>";
          $("#" + view).html(msg);
          $("#" + view).fadeIn();
        }
      });
    }

  }

}
