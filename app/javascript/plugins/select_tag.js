import $ from 'jquery'
import 'select2'
import 'select2/dist/css/select2.css'

export function initSelect2() {
  $('#user_tags').select2();
  $('#offer_tags').select2();
};