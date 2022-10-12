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
    url: String,            // where to do the lookup for data values
    apikey: String,
    employeeAssetId: String,
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
    this.startButtonTarget.classList.add("bg-green-400")
    this.pauseButtonTarget.classList.remove("bg-green-400")
    this.stopButtonTarget.classList.remove("bg-red-400")
    this.sickButtonTarget.classList.remove("bg-yellow-400")

    this.startButtonTarget.disabled = true
    this.stopButtonTarget.disabled = false
    this.pauseButtonTarget.disabled = false
    this.sickButtonTarget.disabled = false

    const elems = document.querySelectorAll('#pupils td.bg-blue-100')
    let pupils = {}
    document.querySelectorAll('#pupils td.bg-blue-100').forEach( e => pupils[e.id]='on')
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "IN", 
      "punched_pupils": pupils,
      }
    }

    this.postPunch( data )

  }

  // button to register employee punching out
  punch_out(e){
    this.stopButtonTarget.classList.add("bg-red-400")
    this.startButtonTarget.classList.remove("bg-green-400")
    this.pauseButtonTarget.classList.remove("bg-green-400")
    this.sickButtonTarget.classList.remove("bg-yellow-400")
        
    this.startButtonTarget.disabled = false
    this.stopButtonTarget.disabled = true
    this.pauseButtonTarget.disabled = true
    this.sickButtonTarget.disabled = true

    const elems = document.querySelectorAll('#pupils td.bg-blue-100')
    elems.forEach( e => e.classList.remove("bg-blue-100"))
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "OUT", 
      }
    }

    this.postPunch( data )
  }

  // button to register employee punching pause/resume
  punch_pause_resume(e){
    this.pauseButtonTarget.classList.add("bg-green-400")
    this.stopButtonTarget.classList.remove("bg-red-400")
    this.startButtonTarget.classList.remove("bg-green-400")
    this.sickButtonTarget.classList.remove("bg-yellow-400")
        
    this.startButtonTarget.disabled = false
    this.stopButtonTarget.disabled = true
    this.pauseButtonTarget.disabled = true
    this.sickButtonTarget.disabled = true

    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": 'BREAK', 
      }
    }

    this.postPunch( data )
  }
  
  // button to register employee punching sick
  punch_sick(e){
    this.sickButtonTarget.classList.add("bg-yellow-400")
    this.pauseButtonTarget.classList.remove("bg-green-400")
    this.stopButtonTarget.classList.remove("bg-red-400")
    this.startButtonTarget.classList.remove("bg-green-400")
        
    this.sickButtonTarget.disabled = true
    this.startButtonTarget.disabled = false
    this.stopButtonTarget.disabled = true
    this.pauseButtonTarget.disabled = true

    const elems = document.querySelectorAll('#pupils td.bg-blue-100')
    elems.forEach( e => e.classList.remove("bg-blue-100"))
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "SICK", 
      }
    }

    this.postPunch( data )
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

  // postPunch
  // transmits the punch
  // and possibly (if told so in the result) asks 
  // the terminal to reload 
  //
  // on error it unshifts the data back on the queue
  // 

  // let urlMethod = "POST";
  // let urlUrl = "";
  // let csrfToken = null;
  // let urlHeaders = "";
  // let apiKey = "";

  // { "asset_work_transaction"=> { 
  //   "punched_at"=>"2022-09-29 12:05:12", 
  //   "state"=>"OUT", 
  //   "employee_id"=>"#{ @emp_one.id }", 
  //   "punch_asset_id"=>"#{ @punch_asset.id }", 
  //   "ip_addr"=>"10.4.3.170" 
  //   }, 
  //   "api_key"=>"[FILTERED]" 
  // }

  // url = `${urlUrl}?api_key=${apiKey}`
  // post_data = {}
  // data.forEach( (v,k) => post_data[k]=v ) 
  // postPunch(url, urlMethod, urlHeaders, { asset_work_transaction: post_data }, data)

  postPunch(data){
    try{
      const csrfToken = document.querySelector("[name='csrf-token']").content
      let headers = { "X-CSRF-Token": csrfToken, "Content-Type": "application/json" }
      let url = `${this.urlValue}?api_key=${this.apikeyValue}`

      let options = {
        method: 'POST',
        // mode: 'no-cors',
        // cache: 'no-cache',
        // redirect: 'follow', 
        // referrerPolicy: 'no-referrer',
        // credentials: 'same-origin',
        // responseKind: "json",
        headers: headers,
        body: JSON.stringify( data )
      }
    
      fetch(url, options)
      .then( response => {
        switch(response.status){
          case 200: console.log('done'); return true;
          case '200': console.log('done - string'); return true;
          case 201: window.location.reload(); return true; 
          case '201': window.location.reload(); return true; 
          case 301: console.log('bad api_key!'); return false;
          default: return false; 
        }
        return true
      } )
      .catch( err => {
        console.log(`postPunch error: ${err}`)
      })
    } catch (err) {
      console.log( `postPunch response: ${err} ` ); return false;
    }
  }

}