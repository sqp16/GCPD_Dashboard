// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require materialize-sprockets
//= require materialize-form
//= require vue
//= require best_in_place
//= require_tree .
//= require jquery-ui
//= require best_in_place.jquery-ui

// @import "materialize";
// @import "https://fonts.googleapis.com/icon?family=Material+Icons";


// Flash fade
$(function() {
   $('.alert-box').fadeIn('normal', function() {
      $(this).delay(3700).fadeOut();
   });
});

$(document).on("click","#yourButton",function(){
  alert("working");
  $("#myform").show();
});

// Best in place functionality
$(document).ready(function() {
  jQuery(".best_in_place").best_in_place();
});

// submits form on change for active/inactive toggli
$(function() {
  $(".auto_submit_form").change(function() {
    this.submit();
  });
});

// Search submit on enter
$(document).ready(function() {
  function submitForm() {
    document.getElementById("search").submit();
  }
  document.onkeydown = function () {
    if (window.event.keyCode == '13') {
        submitForm();
    }
  }
  $("#search-button").click(function() {
    submitForm();
  })
});

// collapsible
$(document).ready(function(){
    $('.collapsible').collapsible();
  });
  
// tabs
$(document).ready(function(){
    $('ul.tabs').tabs();
    swipeable: true
});

      


