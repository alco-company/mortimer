import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class MobileSidebarComponentController extends Controller {
  static targets = [ "mobilesidebar" ]

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

    leave(this.mobilesidebarTarget)
  }

  closeMobileSidebar(e){
    leave(this.mobilesidebarTarget)
  }

  close(event) {
    // leave(this.menuTarget)
  }

  toggle() {
    // if ( this.menuTarget.classList.contains('hidden') ) {
    //   enter(this.menuTarget)
    // } else {
    //   leave(this.menuTarget)
    // }
  }

  handleMessages(e) {
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
  }

}
