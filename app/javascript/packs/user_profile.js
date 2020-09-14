const setCarousel = (jobList) => {
  // add a class to 1st element in the array of carousel
  let track = document.querySelector(`#${jobList} .custom-carousel-track`);
  let slides = Array.from(track.children[0].children);
  let prevButton = document.querySelector(`#${jobList} .custom-carousel-header .custom-controls`).children[0];
  let nextButton = document.querySelector(`#${jobList} .custom-carousel-header .custom-controls`).children[1];
  let slideSize = (slides[0].getBoundingClientRect().width + 24);
  slides[0].className += " current";

  // align all the elements of the array in a linear fashion
  let setSlidePosition = (slide, index) => {
    slides[index].style.left = slideSize * index + "px"
  }

  slides.forEach(setSlidePosition)

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

  nextButton.addEventListener('click', e => {
    let currentSlide = track.querySelector('.current');
    let nextSlide = currentSlide.nextElementSibling;

    moveToSlide(track, currentSlide, nextSlide);
    // Make sure that it cant get off limits
  })
}

setCarousel('saved');
setCarousel('suggested');
setCarousel('posted');
