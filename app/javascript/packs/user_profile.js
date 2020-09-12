import Glide from '@glidejs/glide'

// new Glide('.glide').mount()

let select = document.querySelector('.glide'),
    cardNumber = 1;

if (window.innerWidth > 992) {
    cardNumber = 3;
} else if (window.innerWidth > 600) {
    cardNumber = 2;
}

// Create one per carousel: saved jobs, suggestions, created jobs

let glide = new Glide('.glide', {
  type: 'carousel',
  perView: cardNumber

});


glide.mount()
