import { Controller } from "@hotwired/stimulus"

export default class InputBooleanComponentController extends Controller {
  static targets = [ "input", "toggler", "slider" ]

  connect() {
    this.setSlider()
  }
  
  setSlider(){
    console.log(`hvad er værdien: ${this.inputTarget.value !== true} ?`)
    if ( this.inputTarget.value === "true" ) {
      this.togglerTarget.classList.add("bg-indigo-600")
      this.togglerTarget.classList.remove("bg-gray-200")
      this.sliderTarget.classList.remove("translate-x-0")
      this.sliderTarget.classList.add("translate-x-5")
    } else {
      this.togglerTarget.classList.add("bg-gray-200")
      this.togglerTarget.classList.remove("bg-indigo-600")
      this.sliderTarget.classList.remove("translate-x-5")
      this.sliderTarget.classList.add("translate-x-0")
    }
  }


  toggleBoolean(e) {
    // e.preventDefault()
    //dirty hack !!!
    this.inputTarget.value = (this.inputTarget.value == "true") ? "false" : "true"
    this.setSlider()
  }

}
