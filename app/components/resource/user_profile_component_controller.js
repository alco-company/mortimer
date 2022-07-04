import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class UserProfileComponentController extends Controller {
  static targets = [ "userprofile" ]

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
      leave(this.userprofileTarget)
    }
    
  hideUserProfile(event) {
    // Ignore event if clicked within element
    // if(this.element === event.target || this.element.contains(event.target)) return;

    // leave(this.userprofileTarget)
  }

  toggleUserProfile(e) {
    // e.preventDefault()
    //dirty hack !!!
    document.getElementById('form_slideover').querySelectorAll('form')[0].id="profile_form"
    if ( this.userprofileTarget.classList.contains('hidden') ) {
      enter(this.userprofileTarget)
    } else {
      leave(this.userprofileTarget)
    }
  }

  handleMessages(e) {
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)

    if(e.detail.message==='toggle user profile'){
      this.toggleUserProfile()
    }
  }

}
