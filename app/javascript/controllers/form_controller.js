import { Controller } from "@hotwired/stimulus"

export default class FormController extends Controller {
  static outlets = [ "list", "form-sleeve" ]
  static targets = [ "focus", "copytext" ]
  static values = {
    clipboardPrefix: String
  }

  connect() {
    super.connect()
    document.getElementById("form-sleeve").classList.remove("hidden")
    this.focus()
  }
  
  focus() {
    this.focusTarget.focus()
  }

  copy_text(e){
    let copyField = this.copytextTarget//document.getElementById("asset_assetable_attributes_access_token");
    console.log( this.clipboardPrefixValue )
    
    /* Select the text field */
    copyField.focus()
    copyField.select();
    copyField.setSelectionRange(0, 99999); /* For mobile devices */
    navigator.clipboard.writeText(`${this.clipboardPrefixValue}?api_key=${copyField.value}`);
  }

  keydownHandler(e){
    
    if (e.key === 'Enter') {
      e.preventDefault()
      this.formSleeveOutlet.submitForm()
      // window.dispatchEvent( new CustomEvent("speicherMessage", {
      //   detail: {
      //     message: 'submit form'
      //   }
      // }))
    }
    if (e.key === 'Escape') {
      e.preventDefault()
      this.listOutlet.focusList()
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
