import { Controller } from "@hotwired/stimulus"

export default class ListItemController extends Controller {
  static outlets = [ "list" ]

  connect() {
    super.connect()
    // window.dispatchEvent( new CustomEvent("speicherMessage", {
    //   detail: {
    //     message: 'refocus cursor_position'
    //   }
    // }));    
  }

  tap(e){
    this.listOutlet.logThis('bing')
    // window.dispatchEvent( new CustomEvent("speicherMessage", {
    //   detail: {
    //     message: 'tap item',
    //     event: e
    //   }
    // }));    
  }
  
  handleMessages(e) {
    // console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)

    if(e.detail.message==='tap item'){
      this.toggleAllCheckBoxes(e.detail.event)
    }
  }
}
