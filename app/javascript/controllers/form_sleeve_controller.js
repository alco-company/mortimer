import { Controller } from "@hotwired/stimulus"

export default class FormSleeveController extends Controller {
  static targets = [ "wrapper", "form", "errors", "menu", "overlay" ]
  static classes = [ "elevated" ]

  connect() {
    super.connect()
    document.querySelector('#switchboard')[
      (str => {
      return str
        .split('--')
        .slice(-1)[0]
        .split(/[-_]/)
        .map(w => w.replace(/./, m => m.toUpperCase()))
        .join('')
        .replace(/^\w/, c => c.toLowerCase())
      })(this.identifier)] = this;
    
  }

  handleSuccess({ detail: { success } }) {  
    if (success) {
      this.clearErrors()
      this.formTarget.reset()
      window.dispatchEvent( new CustomEvent("speicherMessage", {
        detail: {
          message: "Submitted",
          sender: 'form'
        },
        bubbles: true
      }))
      
      document.getElementById('form_slideover').querySelectorAll('form')[0].id = document.getElementById('form_slideover').dataset.current_form_slideover || "dashboard_form"
    }
  }

  cancel(){
    this.clearErrors()
    document.getElementById('form_slideover').querySelectorAll('form')[0].id = document.getElementById('form_slideover').dataset.current_form_slideover
    if (this.hasFormTarget){
      document.getElementById("form-sleeve").classList.add("hidden")
      this.formTarget.reset()
    }
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'focus list'
      }
    }));    
  }

  clearErrors() {
    if (this.hasErrorsTarget) {
      this.errorsTarget.remove()
    }
  }

  _hide(){
    this.wrapperTarget.classList.add('hidden')
  }

  _show(){
    this.wrapperTarget.classList.remove('hidden')
  }

  handleMessages(e){
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)

    // if(e.detail.message==='Escape' && e.detail.sender==='form'){
    //   this._hide()
    // }
    if(e.detail.message==='submit form'){
      this.formTarget.requestSubmit() 
    }
    if(e.detail.message==='close slideover'){
      this.clearErrors()
      this.formTarget.reset()
      this._hide()
    }
    if(e.detail.message==='open form'){
      this._show()
      window.dispatchEvent( new CustomEvent("speicherMessage", {
        detail: {
          message: 'focus form field'
        }
      }));  
    }
    if(e.detail.message==='open list form'){
      this._show()
      window.dispatchEvent( new CustomEvent("speicherMessage", {
        detail: {
          message: 'focus form field'
        }
      }));  
    }
  }
}
  