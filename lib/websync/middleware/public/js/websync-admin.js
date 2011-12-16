var websync;
websync = {

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
      statusCode: {
        404: function(data) {
          websync.ui.say_error(data.responseText);
          return false;
        },
        500: function(data) {
          websync.ui.say_error("Sorry something went wrong.");
          $("#main").html("<pre class='container'></pre>");
          $("#main pre").text(data.responseText);
          $("#main").fadeIn();
        }
      },
    });
  },

  error: {
    fatal: function(data) {
      websync.ui.say_error("Sorry something went wrong.");
      $("#error pre").text(data.responseText);
      $("#main").fadeOut(function() {
        $("#error").fadeIn();
      });
    }
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
      $("#error").hide();
      $.ajax({
        type: "GET",
        url: "view/" + view,
        success: function(res) {
          $("#main").html(res);
          $("#main").fadeIn();
        },
        error: websync.error.fatal
      });
    }

  },

  ace: {
    critical: false,
    model: {
      file: null,
      line: null,
      state: "empty"
    },
    editor: null,
    listener: null,
    init: function(where, listener) {
      websync.ace.editor = ace.edit("ace-editor");
      websync.ace.listener = listener; 
      websync.ace.editor.getSession().setUseWrapMode(true);
      websync.ace.editor.setTheme("ace/theme/dawn");
      websync.ace.editor.getSession().on('change', function() {
        if (!websync.ace.critical) {
          websync.ace.update({state: "dirty"});
        }
      });
    },
    load: function(file, line) {
      websync.ace.update({state: "loading"});
      $.ajax({
        type: "GET",
        url: "search/get-file",
        data: {file: file},
        success: function(data) {
          websync.ace.update({
            value: data,
            file:  file,
            line:  line,
            state: "clean"
          });
        },
        error: websync.error.fatal
      });
    },
    update: function(model) {
      websync.ace.critical = true;
      $.extend(websync.ace.model, model);
      if (model.value != undefined && model.value != null) {
        websync.ace.editor.getSession().setValue(model.value);
        websync.ace.editor.focus();
        websync.ace.editor.gotoLine(model.line);
      }
      websync.ace.critical = false;
      websync.ace.listener(websync.ace);
    }
  }

}
