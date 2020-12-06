import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "page" ]

  adjustBackground(){
    if(this.element.classList.contains("dark-mode")) {
      this.element.classList.remove("dark-mode");
    } else {
      this.element.classList.add("dark-mode");
    }
  }

}
