var websync;
websync = {

  start: function(prefix, openMenu) {
    $("head").append('<link rel="stylesheet" href="' + prefix + 'css/websync-admin.css" />');
    $("#local-website-link").attr('href', "/")
    $("#say a").click(function() {
      $("#say").fadeOut();
      return false;
    });
    if (openMenu) {
      $.get(prefix + "view/menu", function(data){
        $("body").append(data);
        $("#websync-admin-link").attr("href", prefix);
      });
    }
  },

  serverCall: function(action, actionData, callback) {
    $.ajax({
      type: 'POST',
      url: "user-request/" + action,
      data: actionData,
      statusCode: {
        404: function(data) {
          callback({result:  "error", 
                    message: "Action " + action + " failed (404 not found)",
                    data: data});
        }
      },
      success: function(data) {
        callback({result:  "success", 
                  message: "Operation successful!",
                  data: data});
      },
      failure: function(data) {
        callback({result:  "error", 
                  message: "Sorry, an error occured.",
                  data: data});
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
      $("body").scrollTo("#" + sel, 800);
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
