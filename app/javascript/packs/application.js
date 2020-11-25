// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
require("jquery")
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap"
import Glide from "@glidejs/glide"
// import "../stylesheets/application"

// Internal imports, e.g:
import { initSelect2 } from '../plugins/select_tag';
import { autocompleteSearch } from '../plugins/autocomplete';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  autocompleteSearch();
  initSelect2();
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()
});


//create a custom container

// verify how wide the thing is so it determines
// how the thing will be showing

// activate controls if we need to activate mobility
// depending on width

//make carousel move

//reload if page resizes

import "controllers"
