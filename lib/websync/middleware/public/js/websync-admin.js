function webSyncInstrument(prefix, openMenu) {
  $("head").append('<link rel="stylesheet" href="' + prefix + 'css/jquery-ui-1.8.16.css" />');
  $("head").append('<link rel="stylesheet" href="' + prefix + 'css/websync-admin.css" />');
  $("head").append('<script src="' + prefix + 'js/jquery-ui-1.8.16.min.js"></script>');
  if (openMenu) {
    $.get(prefix + "view/menu", function(data){
      $("body").append(data);
      $("#websync-admin-link").attr("href", prefix);
    });
  }
}

function webSyncSave(message, callback) {
  $.ajax({
    type: 'POST',
    url: "user-request/save",
    data: { message: $("#save-message").val() },
    success: function(data) {
      callback.success("Nice!");
    },
    error: function(data){
      msg = "<p class='error'>Sorry, something goes wrong during saving</p>"
      callback.failure(msg);
    },
  });
}

function webSyncDeploy(callback) {
  $.ajax({
    type: 'POST',
    url: "user-request/deploy",
    data: {},
    success: function(data) {
      callback.success("Nice!");
    },
    error: function(data){
      msg = "<p class='error'>Sorry, something goes wrong during deployment</p>"
      callback.failure(msg);
    },
  });
}

function webSyncRefreshView(view) {
  $(".ui-dialog").remove();
  $.ajax({
    type: "GET",
    url: "view/" + view,
    success: function(data) {
      $("#" + view).html(data);
    },
    error: function(data) {
      msg = "<p class='feedback error'>Sorry something goes wrong here.</p>";
      $("#" + view).html(msg);
    }
  });
}

function dialogStart(prop) {
  $(prop.selector).dialog({
    width: 400,
    modal: true,
    open: function() {
      $(prop.selector + " form").show();
      $(prop.selector + " .feedback").hide();
      $('.ui-dialog-buttonset').prepend("<img id='ajax-loader' src='css/images/ajax-loader.gif' class='ajax-loader'>");
      $("#ajax-loader").hide();
      $("#dialog-save-button").button("enable");
      $("#dialog-cancel-button").button("enable");
    },
    close: function() {
    },
    buttons: [
      { id: "dialog-save-button",
        text: "Ok",
        click: function() {
          $("#dialog-save-button").button("disable");
          $("#dialog-cancel-button").button("disable");
          $("#ajax-loader").show();
          prop.onOk({
            success: function(msg) {
              $("#ajax-loader").hide();
              $(prop.selector).dialog("close");
              if (prop.onClose != null) { prop.onClose(true); }
            },
            failure: function(msg) {
              $(prop.selector + " form").hide();
              $(prop.selector + " .feedback").html(msg);
              $(prop.selector + " .feedback").show();
              $("#ajax-loader").hide();
              $("#dialog-cancel-button").button("enable");
            } 
          });
        } },
      { id: "dialog-cancel-button", 
        text: "Cancel", 
        click: function() { 
          $(prop.selector).dialog("close");
          if (prop.onClose != null) { prop.onClose(false); }
        } }
    ]
  });
};

