import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class SidebarComponentController extends Controller {
  static targets = [ "sidebar", "accordion" ]
  static values = { index: Number }

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

    leave(this.sidebarTarget)
  }

  close(event) {
    // leave(this.menuTarget)
  }

  toggleGroup(event) {
    this.accordionTargets.forEach((accordion, index) => {
      let accordionIndex = accordion.id.split('-')[1]
      let currentIndex = event.currentTarget.id.split('_')[2]
      if (accordionIndex != currentIndex) {
        accordion.classList.add('hidden')
      } else {
        accordion.classList.contains('hidden') ? accordion.classList.remove('hidden') : accordion.classList.add('hidden')
      }
    })
  }

  openSidebar() {
    enter(this.sidebarTarget)
  }

  handleMessages(e) {
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)

    if(e.detail.message==='open sidebar'){
      this.openSidebar()
    }


  }

}
