import { Controller } from "@hotwired/stimulus"
import { destroy } from '@rails/request.js'

export default class UiModalController extends Controller {
  static targets = [ "container", "cancelaction" ]
  static values = {
    url: String,        // /suppliers/lookup
    ids: String
  }

  connect() {
    super.connect()
    this.toggleClass = "hidden";
    this.open()
  }

  focusModal() {
    this.cancelactionTarget.focus()
  }

  //
  // we'll handle Escape, Enter, ' ', Home, End, ArrowUp, ArrowDown, and Tab
  // and ordinary letters a-z as well
  //
  keyupHandler(e){
    // e.cancelBubble = true;
    // if( e.stopPropagation ) e.stopPropagation();
    // console.log("up " + e.key);

    switch(true){
      case (e.key === '-'): 
        e.preventDefault(); this.close(); return;
      case (e.key === 'Escape'): e.preventDefault(); this.close(); return;
      case (e.key === 'Enter'): e.preventDefault(); return;
      case (e.key === '+'): 
      case (e.key === 'y'): 
      case (e.key === 'Y'): 
      case (e.key === 'j'): 
      case (e.key === 'J'): e.preventDefault(); this.delete();
    }
  }

  keydownHandler(e){
    if (e.key === 'Enter') {
        e.preventDefault();
    }
  }

  delete() {
    if (this.idsValue !== 'undefined'){
      this.idsValue.split(",").forEach(id => {
        destroy( `${this.urlValue.split("?")[0]}/${id}`, {
          responseKind: "turbo-stream"
        })
      });
    }
    this.close(true)
  }

  open() {
    this.containerTarget.classList.remove(this.toggleClass);
    this.cancelactionTarget.focus()
  }

  close(is_deleted) {
    let action = is_deleted ? "delete" : ""
    this.containerTarget.classList.add(this.toggleClass);
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'refocus cursor_position',
        sender: 'ui-modal',
        action: `${action}`
      }
    }));    
  }

  handleMessages(e){
    // console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
    // if(e.detail.message==='open ui-modal'){
    //   console.log('4')
    //   console.log(`modalReady? ${this.modalReady}`)
    //   this.modalReady=true
    //   this.focusModal()
    // }

  }
}
