import { Controller } from "stimulus"

import Rails from "@rails/ujs"

export default class extends Controller {
static targets = [ "inline", "block" ]

  toggle() {
    if(this.inlineTarget.style.display == "none") {
      this.inlineTarget.style.display = "inline-block";
      this.blockTargets.forEach((element) => {
        element.style.display = "block"
      })
    } else {
      this.inlineTarget.style.display = "none";
      this.blockTargets.forEach((element) => {
        element.style.display = "none"
      })
    }
  }

  makeRequest() {
    Rails.ajax({
      type: "post",
      url: this.data.get('url'),
      data: new FormData(this.element)
    })
  }
}
