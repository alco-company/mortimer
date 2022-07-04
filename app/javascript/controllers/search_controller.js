import { Controller } from "@hotwired/stimulus"

export default class SearchController extends Controller {
  static targets = [ "input", "form" ]
  static values = {}

  connect() {
    super.connect()
    console.log(this.inputTarget)
    console.log(this.formTarget)
  }

  search() {
    console.log(this.inputTarget.value)
    // this.formTarget.requestSubmit()
  }
  

  keydownHandler(e){
    
    if (e.key === 'Enter') {
      e.preventDefault()
      this.formTarget.requestSubmit()
      // window.dispatchEvent( new CustomEvent("speicherMessage", {
      //   detail: {
      //     message: 'submit form'
      //   }
      // }))
    }
    if (e.key === 'Escape') {
      e.preventDefault()
      this.inputTarget.value=""
      // window.dispatchEvent( new CustomEvent("speicherMessage", {
      //   detail: {
      //     message: "Escape",
      //     sender: 'form'
      //   },
      //   bubbles: true
      // }))
    }
  }

  handleMessages(e){
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
    if(e.detail.message==='focus form field'){
      this.focus()
    }

  }
}
