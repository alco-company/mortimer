import { Controller } from "@hotwired/stimulus"
import { useTransition } from 'stimulus-use';

export default class MoreController extends Controller {
  static targets = [ "listmoremenu" ]

  connect() {
    super.connect()
    useTransition(this, {
        element: this.listmoremenuTarget,
        enterActive: 'transition ease-out duration-300',
        enterFrom: 'transform opacity-0 scale-95',
        enterTo: 'transform opacity-100 scale-100',
        leaveActive: 'transition ease-in duration-300',
        leaveFrom: 'transform opacity-100 scale-100',
        leaveTo: 'transform opacity-0 scale-95',
        hiddenClass: 'hidden',
        // set this, because the item *starts* in an open state
        transitioned: false,
    });
    
    // this.focus()
  }

  close() {
      this.leave();
  }

  open() {
      this.enter();
  }

  toggle(e){
    // console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
    this.toggleTransition();
    // this.listmoremenuTarget.classList.toggle('hidden')
  }

}

