import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "page" ]

  connect() {
    if (localStorage.nightMode == 'true') this.element.classList.add("dark-mode");
  }

  adjustBackground(){
    if(this.element.classList.contains("dark-mode") ) {
      this.element.classList.remove("dark-mode");
      localStorage.setItem('nightMode', 'false');

    } else {
      this.element.classList.add("dark-mode");
      localStorage.setItem('nightMode', 'true');
    }
  }

}
