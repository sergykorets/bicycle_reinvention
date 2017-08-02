$(document).on('ready page:load', function () {
  $(function() {
    $("#bicycles_search input").keyup(function() {
      $.get($("#bicycles_search").attr("action"), $("#bicycles_search").serialize(), null, "script");
      $(".apple_pagination").hide();
      return false;
    });
  });
});