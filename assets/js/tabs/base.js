let initTabs = function() {
  let $tab_with_error = $(".form-group.has-error").first().closest(".tab-pane");

  if ($tab_with_error.length > 0) {
    $(".nav.nav-tabs").find("a[href^='#" + $tab_with_error.attr('id') + "-']").tab("show");
  } else if (document.location.hash.length > 0) {
    let $tab_from_url = $(".nav.nav-tabs").find("a[href^='" + document.location.hash + "-']");

    if ($tab_from_url.length > 0) {
      document.location.hash = ""; // This prevents scrolling to the wrong place in the page
      $tab_from_url.tab("show");
    }
  }
}

$(document).ready(initTabs);
