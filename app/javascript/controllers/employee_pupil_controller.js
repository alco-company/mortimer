import { Application, Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// 1 Initialize
// 2 Input
// 3 Process Input
// 4 Output
// 5 Misc
export default class EmployeePupilController extends Controller {
  static targets = [ 
  ]
  static values = {
  }

  //
  // 1 Initialize/Connect
  //
  // first we initialize the handset - on every connect
  connect() {
  }

  disconnect() {
    super.disconnect()
  }

  // -- initialize dependant functions

  setReload() {
    if (this.scanset.length < 1) {
      window.location.reload()
    } else {
      this.shouldReload = true
      this.reloadWarningTarget.classList.remove('hidden')
    }
  }

  setPostStatus(status){
    if ( !"200 201".includes(status) ){
      // console.log(`we posted - but got ${status} back!`)
    }
  }


  //
  // 2 Input
  //
  // handle input - listen for keyboard - and functions for reacting to taps

  keydownHandler(e){
    if (e.key === 'Enter') {
      e.preventDefault()
      // let barcode=e.srcElement.value
    }
    if (e.key === 'Escape') {
      e.preventDefault()
    }
  }

  // button to register employee punching in
  toggle_pupil(e){
    if (e.srcElement.classList.contains('bg-blue-100')){
      e.srcElement.classList.remove('bg-blue-100')
    } else {
      e.srcElement.classList.add('bg-blue-100')
    }
  }


  // -- input dependant functions

  //
  // 3 Process Input
  //
  // process input - send good scans to the background worker

  // - process dependant function



  //
  // 4 Output
  //
  // handle output - send good scans to the background worker - and update the UI

  //
  // we queue the scans that are 'ready' - ie holds a SSCS, EAN14, and PRIV at least
  // sending them off to the queue Worker eventually
  //

  // - output dependant functions

  // ***** UI *****

  //
  // 5 Misc
  //
  // support functions like logging and more

  handleMessages(e){
    // console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
  }


}