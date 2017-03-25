// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require moment
//= require bootstrap-datetimepicker

$(document).on('turbolinks:load', function() {
  var currentDate = new Date();
  currentDate.setDate(currentDate.getDate() + 1);

  $('#datetimepicker4').datetimepicker({
    defaultDate: currentDate,
    format: 'YYYY-MM-DD HH:mm'
  });

  $('.countdown').each(function(){
    var p = $(this);
    var date = new Date(p.text()).getTime();

    var x = setInterval(function(){
      var now = new Date().getTime();
      var distance = date - now;

      var days = Math.floor(distance / (1000 * 60 * 60 * 24));
      var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((distance % (1000 * 60)) / 1000);

      p.text("Time left: " + days + "d " + hours + "h " + minutes + "m " + seconds + "s");

      if (distance < 0) {
        clearInterval(x);
        p.text("Auction finished.");
      }
    }, 1000);
  });
});