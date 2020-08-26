import $ from 'jquery'
import 'select2'
import 'select2/dist/css/select2.css'

$(document).on("turbolinks:before-cache", function () {
  if ($('#user_tags').data('select2') != undefined) $('#user_tags').select2('destroy');
});

$(document).on('turbolinks:load', () => {
  $('#user_tags').select2();
});