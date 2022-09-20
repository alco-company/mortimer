import { Application, Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// 1 Initialize
// 2 Input
// 3 Process Input
// 4 Output
// 5 Misc
export default class EmployeePosController extends Controller {
  static targets = [ 
    "startButton",
    "pauseButton",
    "stopButton",
    "sickButton"
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
      this.handleBarcode(e.srcElement.value)
    }
    if (e.key === 'Escape') {
      e.preventDefault()
    }
  }

  // for now tapping the status row listing the queue in the background worker
  // will reload the web app
  emptyQueue(e){
    // TODO: we should POST the logfile (incl all scans) first, to play it safe!
    window.location.reload()
  }

  // button to register employee punching in
  punch_in(e){
    const elems = document.querySelectorAll('#pupils td.bg-blue-100')
    alert(`punch_in ${elems.length}`)
  }

  // button to register employee punching out
  punch_out(e){
    const elems = document.querySelectorAll('#pupils td.bg-blue-100')
    alert(`punch_out ${elems.length}`)
  }

  // button to register employee punching pause/resume
  punch_pause_resume(e){
    const elems = document.querySelectorAll('#pupils td.bg-blue-100')
    alert(`punch_pause/resume ${elems.length}`)
  }
  
  // button to register employee punching sick
  punch_sick(e){
    const elems = document.querySelectorAll('#pupils td.bg-blue-100')
    alert(`punch_sick ${elems.length}`)
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

  tellMap(map, from){
    let type = map.get('type')
    const json = JSON.stringify(Object.fromEntries(map));
    console.log(`Show Map ${from}-${this.scanset.length}-----`)
    console.log(`map ${type} ${ map.get(type) }: `)
    console.log(`${json}`)
    console.log('Show Map ------------------------------ done')
  }

  handleMessages(e){
    // console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
  }


}