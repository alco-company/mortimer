import { Controller } from "@hotwired/stimulus"

export default class FlagController extends Controller {
  // static targets = [ "focus" ]

  connect() {
    super.connect()
    // this.focus()
  }
  
  // focus() {
  //   this.focusTarget.focus()
  // }

  setFlags(e){
  
    let div = document.createElement('div')
    div.id = "flags"
    div.className = "absolute top-0 left-0 py-4 px-4"
    div.innerHTML = `<div class=" bg-slate-100 z-[99] border px-2 py-2 rounded-md flex items-center flex-row">
    <input class="bg-blue-200 flags mr-2 h-4 w-4 border-slate-300 rounded text-slate-600 focus:ring-slate-500" type="checkbox" name="" id="">
    <input class="bg-green-200 flags mr-2 h-4 w-4 border-slate-300 rounded text-slate-600 focus:ring-slate-500" type="checkbox" name="" id="">
    <input class="bg-yellow-200 flags mr-2 h-4 w-4 border-slate-300 rounded text-slate-600 focus:ring-slate-500" type="checkbox" name="" id="">
    <input class="bg-red-200 flags mr-2 h-4 w-4 border-slate-300 rounded text-slate-600 focus:ring-slate-500" type="checkbox" name="" id="">
  </div>`
    
    e.target.offsetParent.appendChild(div)

  }

  keydownHandler(e){
    if (e.key === 'Enter') {
      e.preventDefault()
      window.dispatchEvent( new CustomEvent("speicherMessage", {
        detail: {
          message: 'set flag'
        }
      }))
    }
    if (e.key === 'Escape') {
      e.preventDefault()
      window.dispatchEvent( new CustomEvent("speicherMessage", {
        detail: {
          message: "remove flag input"
        },
        bubbles: true
      }))
    }
  }

  handleMessages(e){
    // console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)


    if(e.detail.message === 'set flag'){
      this.setFlags(e.detail.event)
    }
  }

}

