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

  hide(event) {
    console.log('logout')
  }

  openUserProfile(){
    enter(this.userprofileTarget)
  }

  handleMessages(e) {
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)

    if(e.detail.message==='open user profile'){
      this.openUserProfile()
    }
  }

}
