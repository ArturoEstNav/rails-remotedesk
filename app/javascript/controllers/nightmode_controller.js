import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "page", "toggle" ]

  connect() {
    if (localStorage.nightMode == 'true') {
      this.element.classList.add("dark-mode");
      this.toggleTarget.innerHTML = '<i class="fas fa-sun"></i>';
    }
  }

  adjustBackground(){
    if(this.element.classList.contains("dark-mode") ) {
      this.element.classList.remove("dark-mode");
      localStorage.setItem('nightMode', 'false');
      this.toggleTarget.innerHTML = '<i class="far fa-moon"></i>';

    } else {
      this.element.classList.add("dark-mode");
      localStorage.setItem('nightMode', 'true');
      this.toggleTarget.innerHTML = '<i class="fas fa-sun"></i>';
    }
  }
}
