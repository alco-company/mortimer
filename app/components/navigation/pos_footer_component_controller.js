import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class PosFooterComponentController extends Controller {
  static targets = [ "pos_footer" ]

  connect() {
    super.connect()
  }

  handleClick(e) {
    e.preventDefault()
    console.log(e.target)
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

}
