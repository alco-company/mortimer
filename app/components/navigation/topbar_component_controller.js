import { Controller } from "@hotwired/stimulus"

export default class TopbarComponentController extends Controller {

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

  openSidebar(e){
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'open sidebar'
      }
    }))
  }

  toggleUsermenu(e){
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'open user profile'
      }
    }))
  }

  handleMessages(e) {
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
  }

}
