import { Application, Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"
import { comment } from "postcss"

// 1 Initialize
// 2 Input
// 3 Process Input
// 4 Output
// 5 Misc
export default class EmployeePosController extends Controller {
  static targets = [ 
    "extraButton",
    "extraModal",
    "substituteButton",
    "substituteModal",
    "startButton",
    "pauseButton",
    "stopButton",
    "stopModal",
    "sickButton",
    "sickModal",
    "pupilsList"
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

  enableButtons(focus, enabled,disabled){
    let all_buttons = [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget, this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget]
    all_buttons.forEach( (b) => {
      b.classList.remove("bg-green-400")
      b.disabled = true
    })
    focus.forEach( (b) => {
      b.classList.add("bg-green-400")
    })
    enabled.forEach( (b) => {
      b.disabled = false
    })
    disabled.forEach( (b) => {
      b.disabled = true
    })
  }

  // button to register employee punching in
  punch_in(e){

    this.enableButtons([this.pauseButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget], [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget])    

    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "IN", 
      }
    }

    this.postPunch( data )

  }

  punch_pupil(e) {
    if(e.srcElement.dataset['disabled']=='disabled')
    return

    let state=null
    if (e.srcElement.classList.contains('bg-blue-100')){
      e.srcElement.classList.remove('bg-blue-100')
      state="OUT"
    } else {
      e.srcElement.classList.add('bg-blue-100')
      state="IN"
    }

    let data = { "pupil_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": state, 
      "pupil_id": e.target.dataset.id,
      }
    }

    this.postPunch(data,`${this.urlValue}/pupil_transactions`)

  }

  // button to register employee punching p-time
  punch_in_xtra(e){
    this.extraModalTarget.classList.remove("hidden")
  }

  punch_in_xtra_ok(e){

    this.enableButtons([this.extraButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget], [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget])    

    let comment = document.getElementById('comment').value
    //  {"asset_work_transaction"=>{"punched_at"=>"2022-11-25T10:07:38.249Z", "state"=>"IN", "xtra_time"=>"true", "comment"=>"laver noget skrammel for nogen"}, "api_key"=>"[FILTERED]", "id"=>"7", "employee"=>{}}
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "IN", 
      "extra_time": "true",
      "comment": comment,
      }
    }

    this.postPunch( data )
    this.extraModalTarget.classList.add("hidden")
  }

  punch_in_xtra_cancel(e){
    this.extraModalTarget.classList.add("hidden")
  }

  // button to register employee punching substitute
  punch_in_sub(e){
    this.substituteModalTarget.classList.remove("hidden")
  }

  punch_in_sub_ok(e){

    this.enableButtons([this.substituteButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget], [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget])    

    //  {"asset_work_transaction"=>{"punched_at"=>"2022-11-25T09:20:32.079Z", "state"=>"IN", "location"=>"3", "substitute"=>"true"}, "api_key"=>"[FILTERED]", "id"=>"7", "employee"=>{}}
    let location = document.getElementById('location').value
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "IN", 
      "location": location,
      "substitute": "true"
      }
    }

    this.postPunch( data )
    this.substituteModalTarget.classList.add("hidden")
  }

  punch_in_sub_cancel(e){
    this.substituteModalTarget.classList.add("hidden")
  }

  // button to register employee punching out
  punch_out(e){
    this.stopModalTarget.classList.remove("hidden")
  }

  // {"asset_work_transaction"=>{"punched_at"=>"2022-11-25T09:57:59.644Z", "state"=>"OUT", "comment"=>"text"}, "api_key"=>"[FILTERED]", "id"=>"7", "employee"=>{}}
  punch_out_ok(e){
    this.enableButtons([this.stopButtonTarget],  [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget] )    

    let comment = document.getElementById('comment').value
    const elems = document.querySelectorAll('#pupils td.bg-blue-100')
    let pupils = {}
    document.querySelectorAll('#pupils td.bg-blue-100').forEach( e => pupils[e.id]='off')
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "OUT", 
      "comment": comment,
      }
    }

    this.postPunch( data )
    this.stopModalTarget.classList.add("hidden")
  }

  punch_out_cancel(e){
    this.stopModalTarget.classList.add("hidden")
  }

  // button to register employee punching pause/resume
  punch_pause(e){
    this.enableButtons([this.pauseButtonTarget],  [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget] )    

    const elems = document.querySelectorAll('#pupils td.bg-blue-100')
    let pupils = {}
    document.querySelectorAll('#pupils td.bg-blue-100').forEach( e => pupils[e.id]='off')
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": 'BREAK', 
      "punched_pupils": pupils,
      }
    }

    this.postPunch( data )
  }

  // button to register employee punching substitute
  punch_in_sick(e){
    this.sickModalTarget.classList.remove("hidden")
  }
  
  // button to register employee punching sick
  punch_in_sick_ok(e){

    this.enableButtons([this.sickButtonTarget],  [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget] )    

    //  {"asset_work_transaction"=>{"punched_at"=>"2022-11-25T09:29:53.731Z", "state"=>"SICK", "sick_hrs"=>"3.5", "punched_pupils"=>{}}, "api_key"=>"[FILTERED]", "id"=>"7", "employee"=>{}}
    let sick_hrs = document.getElementById('sick_hrs').value
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "SICK", 
      "sick_hrs": sick_hrs,
      "punched_pupils": pupils,
      }
    }

    this.postPunch( data )
    this.sickModalTarget.classList.add("hidden")
  }

  punch_in_sick_cancel(e){
    this.sickModalTarget.classList.add("hidden")
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

  postPunch(data,url=null){
    try{
      const csrfToken = document.querySelector("[name='csrf-token']").content
      let headers = { "X-CSRF-Token": csrfToken, "Content-Type": "application/json" }
      if (!url )
        url = `${this.urlValue}/punch?api_key=${this.apikeyValue}`
      else
        url = `${url}?api_key=${this.apikeyValue}`

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