import { Controller } from "@hotwired/stimulus"

export default class FormSleeveController extends Controller {
  static outlets = [ "list" ]
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
      // history.back() 
      this.hideForm()
    }
  }

  cancel(){
    this.clearErrors()
    document.getElementById('form_slideover').querySelectorAll('form')[0].id = document.getElementById('form_slideover').dataset.current_form_slideover
    if (this.hasFormTarget){
      document.getElementById("form-sleeve").classList.add("hidden")
      this.formTarget.reset()
    }
    this.listOutlet.focusList()
    // window.dispatchEvent( new CustomEvent("speicherMessage", {
    //   detail: {
    //     message: 'focus list'
    //   }
    // }));    
  }

  clearErrors() {
    if (this.hasErrorsTarget) {
      this.errorsTarget.remove()
    }
  }

  hideForm(){
    this.wrapperTarget.classList.add('hidden')
  }

  showForm(){
    this.wrapperTarget.classList.remove('hidden')
  }

  submitForm(){
    this.formTarget.requestSubmit() 
  }

  handleMessages(e){
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)

    // if(e.detail.message==='submit form'){
    //   this.formTarget.requestSubmit() 
    // }
    if(e.detail.message==='close slideover'){
      this.clearErrors()
      this.formTarget.reset()
      this.hideForm()
    }
    if(e.detail.message==='open form'){
      this.showForm()
      window.dispatchEvent( new CustomEvent("speicherMessage", {
        detail: {
          message: 'focus form field'
        }
      }));  
    }
    if(e.detail.message==='open list form'){
      this.showForm()
      window.dispatchEvent( new CustomEvent("speicherMessage", {
        detail: {
          message: 'focus form field'
        }
      }));  
    }
  }
}
  
// from CoffeeScript
// implementation on db.arkivthy.dk
// 2022, oct - whd

// App.setFormData = () ->
//   form = App.currentForm

//   setField = (e) ->
//     s = "[name='#{e[0]}']"
//     i = form.querySelector s
//     i && i.value = e[1]

//   if localStorage.getItem(this.localStorageKey) != null
//     data = JSON.parse(localStorage.getItem(this.localStorageKey))
//     setField e for e in data

// App.getFormData = () ->
//   f = new FormData(App.currentForm)
//   data = []
//   data.push [e[0], e[1]] for e from f.entries() when e[0] isnt "authenticity_token"
//   data

// App.saveInterval = () ->
//   App.saveToLocalStorage()
//   setTimeout ->
//     App.saveInterval()
//   , 1500

// App.autosave = (form) ->
//   App.currentForm = form
//   App.setFormData()
//   form.addEventListener 'change', () ->
//     App.saveToLocalStorage()
//   App.saveInterval()

// App.saveToLocalStorage = () ->
//   if this.localStorageKey != null
//     localStorage.setItem App.localStorageKey, JSON.stringify(App.getFormData())

// App.clearLocalStorage = () ->
//   console.log 'should clear'
//   if localStorage.getItem(this.localStorageKey) != null
//     console.log "clearing #{this.localStorageKey}..."
//     localStorage.removeItem(this.localStorageKey)
//     this.localStorageKey = null

