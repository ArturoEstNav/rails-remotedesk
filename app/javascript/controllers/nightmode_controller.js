import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "page" ]


  connect() {
    console.log(this.element.classList.contains("crash"))
  }

  adjustBackground(){
    if(this.element.classList.contains("crash")) {
     // this.inlineTarget.style.display = "none";
      console.log("nay")

    } else {
      console.log("yay")
    }
  }

}
