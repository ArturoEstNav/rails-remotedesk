import { Controller } from "stimulus"

export default class extends Controller {
static targets = [ "sign" ]

  connect() {
    console.log(this.signTarget.display);
  }


//  "options", "bar"

// export default class extends Controller {
//   static targets = [ "name" ]

//   greet() {
//     console.log(`Hello, ${this.name}!`)
//   }

//   get name() {
//     return this.nameTarget.value
//   }
// }
