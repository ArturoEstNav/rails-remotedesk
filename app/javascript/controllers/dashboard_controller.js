import { Controller } from "stimulus"

export default class extends Controller {


  toggle() {
    if(hidableElements[0].style.display === "none"){
        hidableElements.forEach((element) => {
          element.style.display === "block"

    else{
      hidableElements.forEach((element) => {
        element.style.display === "none"
      })
    }
  }
}


// export default class extends Controller {
//   static targets = [ "name" ]

//   greet() {
//     console.log(`Hello, ${this.name}!`)
//   }

//   get name() {
//     return this.nameTarget.value
//   }
// }
