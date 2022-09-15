import { Application, Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// 1 Initialize
// 2 Input
// 3 Process Input
// 4 Output
// 5 Misc
export default class EmployeePosController extends Controller {
  static targets = [ 
    "startButton"
  ]
  static values = {
    queueUrl: String,           // where to send queue
    queueMethod: String,        // 
    queueFrequency: String,     // how often to run queue
    queueHeaders: String,       // 
    heartbeatUrl: String,       // where to send heartbeat
    heartbeatFrequency: String, // how often to do heartbeat
    stockId: String,            // what stock
    apiKey: String,             // key to allow access
  }

  //
  // 1 Initialize/Connect
  //
  // first we initialize the handset - on every connect
  connect() {

    // turn on the (background)worker
    this.webWorker(this)
  }

  disconnect() {
    App.webWorker.terminate();
    App.webWorker = undefined;
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

  // call the webworker to get it going
  webWorker(ctrl){

    // first msg starts the background/webworker
    let msg = { 
      url: ctrl.queueUrlValue, 
      method: ctrl.queueMethodValue, 
      api_key: ctrl.apiKeyValue,
      headers: ctrl.queueHeadersValue,
      csrf: document.querySelector(`meta[name=csrf-token]`).content,
      stockid: ctrl.stockIdValue,
      frequency: ctrl.queueFrequencyValue, 
      heartbeat_url: ctrl.heartbeatUrlValue, 
      heartbeat_frequency: ctrl.heartbeatFrequencyValue, 
      cmd: "start" 
    }

    try {
      App.webWorker.postMessage( msg )
 
      App.webWorker.onmessage = function(e) {
        if ("reload" in e.data) { ctrl.setReload() }
        if ("reloadnow" in e.data) { window.location.reload() }
        if ("link_down" in e.data) { ctrl.setConnectionError(ctrl) }
        if ("link_up" in e.data) { ctrl.unsetConnectionError(ctrl)  }
        if ('response' in e.data) {}//{ console.log( e.data.response ); }
        if ('post' in e.data) { ctrl.setPostStatus(e.data["post"]) }
        if ('queueSize' in e.data) { ctrl.setQueueSize(e.data["queueSize"]) }
      }
    } catch(err) {
      this.warn_to_reload("Fejl under indlæsning - prøv at genindlæse!")
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
    alert('punch_in')
  }

  // button to register employee punching out
  punch_out(e){
  }

  // button to register employee punching pause/resume
  punch_pause_resume(e){
  }

  // button to register employee punching sick
  punch_sick(e){
  }

  // -- input dependant functions

  //
  // 3 Process Input
  //
  // process input - send good scans to the background worker
  processBarcode(barcode){

    let scanMap = new Map([['barcode', barcode]]);
    // what barcode is it?
    let scan = this.decipherBarcode( scanMap, this.barcode_types )
    if (scan.get('type')==='sscs'){
      this.totalScans += 1
      this.scansetCountTarget.innerText = this.totalScans      
    }

    // queue the barcode - and if good - process the set to see if any should get sent
    if (this.queueScanset(scan)) {
      this.updateUI()
      this.processScanset()
      this.focusTarget.value = ''
    }

  }

  // - process dependant function



  //
  // 4 Output
  //
  // handle output - send good scans to the background worker - and update the UI

  //
  // we queue the scans that are 'ready' - ie holds a SSCS, EAN14, and PRIV at least
  // sending them off to the queue Worker eventually
  //
  processScanset(){

    let processQueue = [],
        map = null,
        count = this.scanset.length

    if (this.shouldReload) {
      try{App.webWorker.postMessage({ loadondone: true })} catch(err){this.warn_to_reload('Kunne ikke aflevere besked - prøv at genindlæse!')}
      this.focusTarget.classList.add('disabled')
    }
    if (count < 1)
      return

    while( typeof (map = this.scanset.pop()) !== 'undefined' ) {
      map.set('direction', this.direction)
      switch(true){
        case ((this.direction=='RECEIVE') && this.receiveReady(map)): this.receiveScan(map); break;
        case ((this.direction=='SHIP') && this.shipReady(map)): this.shipScan(map); break;
        default: processQueue.push(map); //this.tellMap(map,`processScanset - map not ready!! ${count}`)
      }
    }

    while( typeof (map = processQueue.pop()) !== 'undefined' ) {
      this.scanset.unshift(map)
    }
    if (this.scanset.length<1) {
      this.sessionRequiredIdentifiers = this.requiredIdentifiers
      this.commonScans = []  
      switch(true){
        case (this.direction=='RECEIVE'): this.resetReceivePath(); break;
        case (this.direction=='SHIP'): this.resetShipPath(); break;
      }
    }
  }

  // - output dependant functions

  receiveReady(map){
    // if ( map.get('location')!=undefined )
    //   this.tellMap(map,'From ProcessScanset') 
    return ((map.get('sscs')!='') && (map.get('ean14')!='') && (map.get('location')!=''))
  }
  
  shipReady(map){
    // if ( map.get('location')!=undefined )
    //   this.tellMap(map,'From ProcessScanset')
    return (map.get('sscs')!='')
  }

  // send this shipping scan to the worker
  shipScan(map){
    map.set('unit', 'pallet')
    // this.tellMap(map,'shipping')
    try{App.webWorker.postMessage({ data: map })} catch(err){this.warn_to_reload('Kan ikke sende data - seneste indlæsninger kan være tabt!') }
    
  }
  
  // send this receiving goods scan to the worker
  receiveScan(map){
    map.set('unit', 'pallet')
//    this.tellMap(map,'receiveScan -> off to worker')
    try{App.webWorker.postMessage({ data: map })} catch(err){this.warn_to_reload('Kan ikke sende data - seneste indlæsninger kan være tabt!')}
    
  }

  // ***** UI *****

  resetReceivePath(){
    this.stepEAN14Target.classList.remove('hidden')
    this.stepSSCSTarget.classList.remove('hidden')
    this.stepLOCTarget.classList.remove('hidden')

    this.addGreen(this.receiveButtonTarget)
    this.removeGreen(this.inventoryButtonTarget)
    this.removeYellow(this.shipButtonTarget)

    this.grayIcon(this.barcodeIconSSCSTarget)
    this.grayIcon(this.barcodeIconEAN14Target)
    this.grayIcon(this.barcodeIconLOCTarget)
    this.barcodeTextEAN14Target.innerHTML=""
    this.barcodeTextSSCSTarget.innerHTML=""
    this.barcodeTextLOCTarget.innerHTML=""

    this.scansetCountTarget.innerText = this.totalScans      
    this.resetQueueStatus()
  }

  resetInventoryPath(){
    this.stepSSCSTarget.classList.remove('hidden')
    this.stepEAN14Target.classList.add('hidden')
    this.stepLOCTarget.classList.add('hidden')

    this.removeGreen(this.receiveButtonTarget)
    this.addGreen(this.inventoryButtonTarget)
    this.removeYellow(this.shipButtonTarget)

    this.grayIcon(this.barcodeIconSSCSTarget)
    this.barcodeTextSSCSTarget.innerHTML=""

    this.scansetCountTarget.innerText = this.totalScans      
  }

  resetShipPath(){
    this.stepSSCSTarget.classList.remove('hidden')
    this.stepEAN14Target.classList.add('hidden')
    this.stepLOCTarget.classList.add('hidden')

    this.removeGreen(this.receiveButtonTarget)
    this.removeGreen(this.inventoryButtonTarget)
    this.addYellow(this.shipButtonTarget)

    this.grayIcon(this.barcodeIconSSCSTarget)
    this.barcodeTextSSCSTarget.innerHTML=""

    this.scansetCountTarget.innerText = this.totalScans      
  }

  grayIcon(elem){
    elem.classList.remove('bg-green-500')
    elem.classList.add('bg-gray-400')
  }

  greenIcon(elem){
    elem.classList.add('bg-green-500')
    elem.classList.remove('bg-gray-400')
  }

  removeGreen(btn){
    btn.classList.remove("bg-green-600","text-sm","font-medium","text-gray-100","hover:bg-green-500","focus:z-10","focus:outline-none","focus:ring-1","focus:ring-green-400","focus:border-green-300")
    btn.classList.add("bg-white","text-sm","font-medium","text-gray-700","hover:bg-gray-50","focus:z-10","focus:outline-none","focus:ring-1","focus:ring-indigo-500","focus:border-indigo-500")
  }

  addGreen(btn){
    btn.classList.remove("bg-white","text-sm","font-medium","text-gray-700","hover:bg-gray-50","focus:z-10","focus:outline-none","focus:ring-1","focus:ring-indigo-500","focus:border-indigo-500")
    btn.classList.add("bg-green-600","text-sm","font-medium","text-gray-100","hover:bg-green-500","focus:z-10","focus:outline-none","focus:ring-1","focus:ring-green-400","focus:border-green-300")
  }

  removeYellow(btn){
    btn.classList.remove("bg-yellow-600","text-sm","font-medium","text-gray-100","hover:bg-yellow-500","focus:z-10","focus:outline-none","focus:ring-1","focus:ring-yellow-400","focus:border-yellow-300")
    btn.classList.add("bg-white","text-sm","font-medium","text-gray-700","hover:bg-gray-50","focus:z-10","focus:outline-none","focus:ring-1","focus:ring-indigo-500","focus:border-indigo-500")
  }

  addYellow(btn){
    btn.classList.remove("bg-white","text-sm","font-medium","text-gray-700","hover:bg-gray-50","focus:z-10","focus:outline-none","focus:ring-1","focus:ring-indigo-500","focus:border-indigo-500")
    btn.classList.add("bg-yellow-600","text-sm","font-medium","text-gray-100","hover:bg-yellow-500","focus:z-10","focus:outline-none","focus:ring-1","focus:ring-yellow-400","focus:border-yellow-300")
  }

  warn_to_reload(msg){
    this.queueStatusTarget.innerText=msg
    this.queueIconTarget.classList.add("bg-red-500","text-white")
    this.focusTarget.classList.add('disabled')
  }

  resetQueueStatus(msg='Antal paller i kø til server'){
    this.queueStatusTarget.innerText=msg
    this.queueIconTarget.classList.remove("bg-red-500","text-white")
    this.focusTarget.classList.remove('disabled')
  }

  updateUI(){
    let uiset = [...this.scanset, ...this.commonScans],
      map = 'undefined'

    try {      
      while(  typeof (map = uiset.pop()) !== 'undefined' ) {
        ['sscs','batchnbr','ean14','location'].map( lbl => {
          switch(true){
            case map.get('sscs')!=='':         this.setSSCS(map); break;
            case map.get('batchnbr')!=='':     this.setSSCS(map); break;
            case map.get('ean14')!=='':        this.setProduct(map); break;
            // case map.get('type')==='cust-1':   this.setProduct(map);
            case map.get('location')!=='':     this.setLocation(map); break;
          }
        })
      }  
    } catch (error) {
      console.log(`error updating the UI: ${error}`)
    }
  }

  // setSSCS adds a pallet barcode to either a new tuple or the first tuple with no pallet barcode
  //
  // <p>123456789012345679</p>
  // <p>serie/batch 123457</p>
  setSSCS(scan){
    var txt = `<p>SSCS ${scan.get('sscs')}</p><p>serie/batch ${scan.get('batchnbr')} </p>`
    this.barcodeTextSSCSTarget.innerHTML = txt
    return true;
  }
  
  // setProduct either inserts a new scan at the top of
  // the scanset - or adds the ean14 scan to all current
  // scans that do not have an ean14
  // and then writes the content to the UI barcodeTextEAN14 element
  // <p>1522050202057104261010293725</p>
  // <p>bedst inden 22050202</p>
  // <p>kolli ialt  25</p>
  setProduct(scan){
    var txt = `<p>ean14 ${scan.get('ean14')}</p><p> bedst inden ${scan.get('sell')}</p><p>antal kolli ${scan.get('nbrcont')}</p>`
    this.barcodeTextEAN14Target.innerHTML = txt    
    return true;
  }
  
  setLocation(scan){
    let location = this.locations.filter( l => l.location_barcode == scan.get('location'))
    location = location.length > 0 ? location[0].name : scan.get('location')
    this.barcodeTextLOCTarget.innerHTML = location
    return true;
  }

  setQueueSize(size){
    this.queueCountTarget.innerText = size
    this.resetQueueStatus()
  }

  setConnectionError(ctrl){
    ctrl.brokenErrorTarget.classList.remove('hidden')
    ctrl.queueIconTarget.classList.add("text-red-600")
  }

  unsetConnectionError(ctrl){
    ctrl.brokenErrorTarget.classList.add('hidden')
    ctrl.queueIconTarget.classList.remove("bg-red-500","text-white")
  }

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