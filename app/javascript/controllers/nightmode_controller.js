import { Controller } from "stimulus"

export default class extends Controller {
static targets = [ "toggle" ]

  adjustBackground() {
    console.log("hi there")
  }

}
