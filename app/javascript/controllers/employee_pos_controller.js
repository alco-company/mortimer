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
    "freeButton",
    "freeModal",
    "pupilsList",
    "min15Button",
    "min15Modal",
    "taskModal"
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
    // alert('Det er nødvendigt at kende din lokation - for at sikre dig mod at andre misbruger denne tjeneste! Tillad derfor venligst at programmet må slå op, hvor du befinder dig. På forhånd tak <3')
    this.geo_position = ''
    this.find_my_location()
    // this.socket = new WebSocket('ws://localhost:3000/cable'); // 'wss://staging.greybox.speicher.ltd/cable'
    // if (window.cable){
    //   console.log(window.cable)
    // }
    this.addOfflineListener()
  }

  disconnect() {
    super.disconnect()
  }

  // -- initialize dependant functions

  addOfflineListener() {
    window.addEventListener('offline', (event) => {
      document.getElementById('work_status').innerHTML='<span class="">Du har ingen netværksforbindelse - og kan derfor ikke registrere din arbejdstid. Vent venligst på at du får forbindelse igen, og prøv så igen.</span>'
      document.getElementById('work_status').classList.add('px-2', 'py-2', 'bg-red-200', 'text-red-800')
    })
    window.addEventListener('online', (event) => {
      window.location.reload()
    })
  }

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
    let all_buttons = [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget, this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget, this.min15ButtonTarget]
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
    this.find_my_location()
    this.enableButtons([this.pauseButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget], [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget, this.freeButtonTarget, this.min15ButtonTarget])    

    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "IN", 
      }
    }

    this.postPunch( data )

  }

  punch_pupil(e) {
    console.log('punch_pupil')
    this.find_my_location()
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
      "employee_asset_id": this.employeeAssetIdValue,
      "state": state, 
      "pupil_id": e.target.dataset.id,
      }
    }

    this.postPunch(data,`${this.urlValue}/pupil_transactions`)

  }

  // button to register employee punching p-time
  punch_in_xtra(e){
    this.find_my_location()
    this.extraModalTarget.classList.remove("hidden")
  }

  punch_in_xtra_ok(e){

    this.enableButtons([this.extraButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget], [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget, this.freeButtonTarget, this.min15ButtonTarget])    

    let comment = document.getElementById('xtra_comment').value
    document.getElementById('xtra_comment').value = ''
    //  {"asset_work_transaction"=>{"punched_at"=>"2022-11-25T10:07:38.249Z", "state"=>"IN", "xtra_time"=>"true", "comment"=>"laver noget skrammel for nogen"}, "api_key"=>"[FILTERED]", "id"=>"7", "employee"=>{}}
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "IN", 
      "punched_pupils": this.close_active_pupils({}),
      "reason": "XTRA",
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
    this.find_my_location()
    this.substituteModalTarget.classList.remove("hidden")
  }

  punch_in_sub_ok(e){

    this.enableButtons([this.substituteButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget], [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget, this.freeButtonTarget, this.min15ButtonTarget])    

    //  {"asset_work_transaction"=>{"punched_at"=>"2022-11-25T09:20:32.079Z", "state"=>"IN", "location"=>"3", "substitute"=>"true"}, "api_key"=>"[FILTERED]", "id"=>"7", "employee"=>{}}
    let location = document.getElementById('substitute_reason').value
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "IN", 
      "punched_pupils": this.close_active_pupils({}),
      "reason": "SUB",
      "comment": location
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
    this.find_my_location()
    this.stopModalTarget.classList.remove("hidden")
  }

  // {"asset_work_transaction"=>{"punched_at"=>"2022-11-25T09:57:59.644Z", "state"=>"OUT", "comment"=>"text"}, "api_key"=>"[FILTERED]", "id"=>"7", "employee"=>{}}
  punch_out_ok(e){
    this.enableButtons([this.stopButtonTarget],  [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget, this.freeButtonTarget, this.min15ButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget] )    

    let comment = document.getElementById('stop_comment').value
    document.getElementById('stop_comment').value = ''
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "OUT", 
      "punched_pupils": this.close_active_pupils({}),
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
    this.find_my_location()
    this.enableButtons([this.pauseButtonTarget],  [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget, this.freeButtonTarget, this.min15ButtonTarget] )    

    let pupils = {}
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": 'BREAK', 
      "punched_pupils": this.close_active_pupils({}),
      }
    }

    this.postPunch( data )
  }

  // button to register employee punching sick
  punch_in_sick(e){
    this.find_my_location()
    this.sickModalTarget.classList.remove("hidden")
  }
  
  // button to register employee punching sick ok
  punch_in_sick_ok(e){

    this.enableButtons([this.sickButtonTarget],  [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget, this.freeButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget, this.min15ButtonTarget] )    

    //  {"asset_work_transaction"=>{"punched_at"=>"2022-11-25T09:29:53.731Z", "state"=>"SICK", "sick_hrs"=>"3.5", "punched_pupils"=>{}}, "api_key"=>"[FILTERED]", "id"=>"7", "employee"=>{}}
    let sick_hrs = document.getElementById('sick_hrs').value
    let reason = document.getElementById('sick_reason').value
    document.getElementById('sick_reason').value=''
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "state": "SICK", 
      "sick_hrs": sick_hrs,
      "reason": reason,
      "punched_pupils": this.close_active_pupils({}),
      }
    }

    this.postPunch( data )
    this.sickModalTarget.classList.add("hidden")
  }

  // button to register employee punching sick cancel modal
  punch_in_sick_cancel(e){
    this.sickModalTarget.classList.add("hidden")
  }

  // button to register employee punching free
  punch_in_free(e){
    this.find_my_location()
    this.freeModalTarget.classList.remove("hidden")
  }
  
  // button to register employee punching free
  punch_in_free_ok(e){

    this.enableButtons([this.freeButtonTarget],  [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget, this.freeButtonTarget, this.min15ButtonTarget] )    

    //  {"asset_work_transaction"=>{"punched_at"=>"2022-11-25T09:29:53.731Z", "state"=>"SICK", "sick_hrs"=>"3.5", "punched_pupils"=>{}}, "api_key"=>"[FILTERED]", "id"=>"7", "employee"=>{}}
    let free_hrs = document.getElementById('free_hrs').value
    let reason = document.getElementById('free_reason').value
    document.getElementById('free_reason').value=''
    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "punched_pupils": this.close_active_pupils({}),
      "state": "FREE", 
      "free_hrs": free_hrs,
      "reason": reason,
      }
    }

    this.postPunch( data )
    this.freeModalTarget.classList.add("hidden")
  }

  // button to register employee punching free cancel modal
  punch_in_free_cancel(e){
    this.freeModalTarget.classList.add("hidden")
  }

  punch_in_15min(e){
    this.find_my_location()
    this.min15ModalTarget.classList.remove("hidden")
  }

  punch_in_15min_ok(e){

    this.enableButtons([, this.min15ButtonTarget ],  [this.extraButtonTarget,this.substituteButtonTarget, this.startButtonTarget, this.min15ButtonTarget], [this.pauseButtonTarget, this.stopButtonTarget, this.sickButtonTarget, this.freeButtonTarget] )    
    let comment = document.getElementById('15min_comment').value
    document.getElementById('15min_comment').value = ''

    let data = { "asset_work_transaction": { 
      "punched_at": new Date().toISOString(), 
      "reason": "15MIN",
      "comment": comment,
      "state": "IN", 
      }
    }

    this.postPunch( data )
    this.min15ModalTarget.classList.add("hidden")

  }    

  // button to register employee punching free cancel modal
  punch_in_15min_cancel(e){
    this.min15ModalTarget.classList.add("hidden")
  }

  punch_in_task(e){
    this.find_my_location()
    this.taskModalTarget.classList.remove("hidden")
  }



  // -- input dependant functions

  //
  // 3 Process Input
  //
  // process input - send good scans to the background worker

  // 
  // make sure we close all currently running counters 
  //
  close_active_pupils(pupils){
    const elems = document.querySelectorAll('#pupils td.bg-blue-100')
    document.querySelectorAll('#pupils td.bg-blue-100').forEach( e => pupils[e.id]='off')
    return pupils
  }

  // - find navigator location
  find_my_location(){
    try{
      this.get_position()
      .then( coords => this.geo_position = `${coords.latitude},${coords.longitude},location retrieved!` )
      .catch( error => {
        fetch('http://ip-api.com/json')
        .then( response => response.json())
        .then( json =>  this.geo_position = `${json.lat},${json.lon},(approx) location retrieved - user probably declined GeoLocation services (${error} )!`)
      })
    } catch (err) {
      console.log(`find_my_location: ${err}`)
    }
  }

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

  get_position(options) {
    return new Promise((resolve, reject) =>
      navigator.permissions ?

        // Permission API is implemented
        navigator.permissions.query({
          name: 'geolocation'
        }).then(permission =>
          // is geolocation granted?
          permission.state === "granted"
            ? navigator.geolocation.getCurrentPosition(pos => resolve(pos.coords)) 
            : reject(new Error("User did not grant permission to access device geolocation information"))
        ) :

      // Permission API was not implemented
      navigator.geolocation ?
          navigator.geolocation.getCurrentPosition(pos => resolve(pos.coords)) :
      reject(new Error("Permission API is not supported - and navigator.geolocation not available"))
    )
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

      try {
        data.asset_work_transaction.location = this.geo_position
      } catch ( err ) {
        // data.pupil_transaction.location = this.geo_position
        console.log(`no location: ${err}`)
      }

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