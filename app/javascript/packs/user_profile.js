// import Glide from '@glidejs/glide'

// let select = document.querySelector('.glide');

  // Create one per carousel: saved jobs, suggestions, created jobs

  // console.log(saved);

  // let glide = new Glide('.glide', {
  //   type: 'carousel',
  //   perView: cardNumber

  // })

  // let suggested = new Glide('.suggested', {
  //   type: 'carousel',
  //   perView: cardNumber

  // })

  // let posted = new Glide('.posted', {
  //   type: 'carousel',
  //   perView: cardNumber

  // })

  // glide.mount();
  // suggested.mount();
  // posted.mount();

// add a class to 1st element in the array of carousel
let track = document.querySelector('#saved .custom-carousel-track');
let slides = Array.from(track.children[0].children);
let prevButton = document.querySelector('#saved .custom-carousel-header .custom-controls').children[0];
let nextButton = document.querySelector('#saved .custom-carousel-header .custom-controls').children[1];
let slideSize = (slides[0].getBoundingClientRect().width + 24);
slides[0].className += " current";

// align all the elements of the array in a linear fashion
let setSlidePosition = (slide, index) => {
  slides[index].style.left = slideSize * index + "px"
}
slides.forEach(setSlidePosition)
// movr backward
const moveToSlide = (track, currentSlide, targetSlide) => {
  // move to next offer
  track.style.transform = 'translateX(-' + targetSlide.style.left + ')';
  currentSlide.className = "custom-carousel-slide"
  targetSlide.className += " current";
}

prevButton.addEventListener('click', e => {
  let currentSlide = track.querySelector('.current');
  let prevSlide = currentSlide.previousElementSibling;

  moveToSlide(track, currentSlide, prevSlide);
})
// move forward


nextButton.addEventListener('click', e => {
  let currentSlide = track.querySelector('.current');
  let nextSlide = currentSlide.nextElementSibling;

  moveToSlide(track, currentSlide, nextSlide);
})
// using widths and position relative
console.log(slideSize)
