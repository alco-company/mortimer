import { Controller } from "@hotwired/stimulus"

export default class TopbarComponentController extends Controller {
  static outlets = [ "navigation--mobile-sidebar-component" ]

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

  closeSidebar(e){
    this.navigationMobileSidebarComponentOutlet.closeSidebar(e)
    // window.dispatchEvent( new CustomEvent("speicherMessage", {
    //   detail: {
    //     message: 'close mobile sidebar',
    //     event: e
    //   }
    // }))
  }

  openSidebar(e){
    this.navigationMobileSidebarComponentOutlet.openSidebar(e)
    // window.dispatchEvent( new CustomEvent("speicherMessage", {
    //   detail: {
    //     message: 'open mobile sidebar'
    //   }
    // }))
  }

  // toggleUsermenu(e){
  //   window.dispatchEvent( new CustomEvent("speicherMessage", {
  //     detail: {
  //       message: 'toggle user profile'
  //     }
  //   }))
  // }

  handleMessages(e) {
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
  }

}
