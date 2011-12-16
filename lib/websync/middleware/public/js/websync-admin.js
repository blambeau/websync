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
      $("#topbar a.brand").attr('href', prefix);
      $("#topbar .nav a").click(function() {
        if ($(this).attr('href') == '/') {
          return true;
        } else {
          websync.ui.refresh($(this).attr('href'));
          return false;
        }
      });
    });
    if (admin) { this.ui.refresh("welcome"); }
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

  search: function(data, callback) {
    $.ajax({
      type: "GET",
      url: "search",
      data: data,
      success: callback,
      error: function(data) {
        websync.ui.say_error("Sorry something went wrong.");
        $("#main").html("<pre class='container'></pre>");
        $("#main pre").text(data.responseText);
        $("#main").fadeIn();
      }
    });
  },

  /*
   * Set of function for handling the UI
   */
  ui: {

    say: function(data) {
      $("#say p").html(data.message);
      $("#say").attr("class", "alert-message " + data.msgType);
      $("#say").slideDown().delay("1000").fadeOut();
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
      $.ajax({
        type: "GET",
        url: "view/" + view,
        success: function(res) {
          $("#main").html(res);
          $("#main").fadeIn();
        },
        error: function(data) {
          websync.ui.say_error("Sorry something went wrong.");
          $("#main").html("<pre class='container'></pre>");
          $("#main pre").text(data.responseText);
          $("#main").fadeIn();
        }
      });
    }

  }

}
