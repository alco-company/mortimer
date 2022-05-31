import { Controller } from "@hotwired/stimulus"

export default class ListItemController extends Controller {

  connect() {
    super.connect()
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'refocus cursor_position'
      }
    }));    
  }

  tap(e){
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'tap item',
        event: e
      }
    }));    
  }
  
  handleMessages(e) {
    // console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)

    if(e.detail.message==='tap item'){
      this.toggleAllCheckBoxes(e.detail.event)
    }
  }
}
