import { Application, Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// 
export default class StockPosController extends Controller {
  static targets = [ 
    "focus", 
    "brokenError", 
    "reloadWarning", 
    "queueIcon", 
    "queueStatus", 
    "queueCount", 
    "scansetIcon",
    "scansetCount",
    "stepEAN14",
    "stepSSCS",
    "stepLOC",
    "barcodeIconSSCS",
    "barcodeIconEAN14",
    "barcodeIconLOC",
    "barcodeTextSSCS",
    "barcodeTextEAN14",
    "barcodeTextLOC",
    "receiveButton", 
    "inventoryButton", 
    "shipButton" 
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

  connect() {
    // scanset holds an array of scan 
    // every scan is a Map/labeled array like { barcode: '123123...', ean14: 571234567890123, ... }
    this.scanset = [];
    this.totalScans = 0;
    this.sscsset = [];
    this.direction = "";
    this.shouldReload = false;
    super.connect()
    this.webWorker(this)
    this.focus()
  }

  disconnect() {
    App.webWorker.terminate();
    App.webWorker = undefined;
    super.disconnect()
  }
  
  focus() {
    this.focusTarget.focus()
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

  setQueueSize(size){
    this.queueCountTarget.innerText = size
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

  setConnectionError(ctrl){
    ctrl.brokenErrorTarget.classList.remove('hidden')
    ctrl.queueIconTarget.classList.add("text-red-600")
  }

  unsetConnectionError(ctrl){
    ctrl.brokenErrorTarget.classList.add('hidden')
    ctrl.queueIconTarget.classList.remove("bg-red-500","text-white")
  }



  copy_text(e){
    let copyField = document.getElementById("asset_assetable_attributes_access_token");
    // console.log( this.clipboardPrefixValue )
    
    /* Select the text field */
    copyField.focus()
    copyField.select();
    copyField.setSelectionRange(0, 99999); /* For mobile devices */
    navigator.clipboard.writeText(`${this.clipboardPrefixValue}?api_key=${copyField.value}`);

    // console.log(`Copied the text: ${copyField.value}`)    
  }

  grayIcon(elem){
    elem.classList.remove('bg-green-500')
    elem.classList.add('bg-gray-400')
  }

  greenIcon(elem){
    elem.classList.add('bg-green-500')
    elem.classList.remove('bg-gray-400')
  }

  // send this scan to the worker
  shipScan(map){
    map.set('unit', 'pallet')
    this.tellMap(map,'shipping')
    try{App.webWorker.postMessage({ data: map })} catch(err){this.warn_to_reload('Kan ikke sende data - seneste indlæsninger kan være tabt!') }
    this.grayIcon(this.barcodeIconSSCSTarget)
    this.barcodeTextSSCSTarget.innerHTML=""
    this.totalScans += 1
    this.scansetCountTarget.innerText = this.totalScans
  }
  
  // send this scan to the worker
  receiveScan(map){
    map.set('unit', 'pallet')
    this.tellMap(map,'receiving')
    try{App.webWorker.postMessage({ data: map })} catch(err){this.warn_to_reload('Kan ikke sende data - seneste indlæsninger kan være tabt!')}
    this.grayIcon(this.barcodeIconSSCSTarget)
    this.grayIcon(this.barcodeIconEAN14Target)
    this.grayIcon(this.barcodeIconLOCTarget)
    this.barcodeTextEAN14Target.innerHTML=""
    this.barcodeTextSSCSTarget.innerHTML=""
    this.barcodeTextLOCTarget.innerHTML=""
  }

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
        case ((this.direction=='RECEIVE') && (map.get('sscs')!=undefined) && (map.get('ean14')!=undefined) && (map.get('location')!=undefined)): this.receiveScan(map); break;
        case ((this.direction=='SHIP') && (map.get('sscs')!=undefined)): this.shipScan(map); break;
        default: processQueue.push(map); //this.tellMap(map,`processScanset - map not ready!! ${count}`)
      }
    }

    while( typeof (map = processQueue.pop()) !== 'undefined' ) {
      this.scanset.unshift(map)
    }
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

  emptyQueue(e){
    // TODO: we should POST the logfile (incl all scans) first, to play it safe!
    window.location.reload()
  }

  receive_goods(e){
    this.sscsset = [];
    this.totalScans = 0;
    this.stepEAN14Target.classList.remove('hidden')
    this.stepSSCSTarget.classList.remove('hidden')
    this.stepLOCTarget.classList.remove('hidden')
    this.addGreen(this.receiveButtonTarget)
    this.removeGreen(this.inventoryButtonTarget)
    this.removeYellow(this.shipButtonTarget)
    this.direction = "RECEIVE"
    this.processScanset()
    this.focusTarget.focus()
  }
  do_inventory(e){
    this.sscsset = [];
    this.totalScans = 0;
    this.stepEAN14Target.classList.add('hidden')
    this.stepSSCSTarget.classList.remove('hidden')
    this.stepLOCTarget.classList.add('hidden')
    this.removeGreen(this.receiveButtonTarget)
    this.addGreen(this.inventoryButtonTarget)
    this.removeYellow(this.shipButtonTarget)
    this.direction = "INVENTORY"
    this.processScanset()
    this.focusTarget.focus()

  }
  ship_goods(e){
    this.sscsset = [];
    this.totalScans = 0;
    this.stepEAN14Target.classList.add('hidden')
    this.stepSSCSTarget.classList.remove('hidden')
    this.stepLOCTarget.classList.add('hidden')
    this.removeGreen(this.receiveButtonTarget)
    this.removeGreen(this.inventoryButtonTarget)
    this.addYellow(this.shipButtonTarget)
    this.direction = "SHIP"
    this.processScanset()
    this.focusTarget.focus()

  }

  isSscs(barcode){
    var reg_sscs = /^00\d{18}/;
    var result = reg_sscs.test(barcode)
    return result;
  }

  sscsSetContains(barcode){
    if (this.sscsset.filter( b => b === barcode ).length > 0)
      return true;
    this.sscsset.push(barcode)
    return false;
  }

  sscsBarcodeExist(barcode){
    if (this.isSscs(barcode) && this.sscsSetContains(barcode)) {
      return true;
    }
    return false;
  }

  keydownHandler(e){
    if (e.key === 'Enter') {
      e.preventDefault()
      let barcode=e.srcElement.value
      if (this.sscsBarcodeExist(barcode)) {
        this.focusTarget.value = ''
        return false
      }

      let scanMap = new Map([['barcode', barcode]]);
      let decipheredScan = this.decipherBarcode( scanMap )
      if (this.prepScanset(decipheredScan)) {
        this.processScanset()
        this.focusTarget.value = ''
      }
    }
    if (e.key === 'Escape') {
      e.preventDefault()
    }
  }

  //
  // decipherBarcode uses any downloaded masks to decide what a particlar
  // scan is
  // current it may be a GS1-128 (previously known as EAN/UCC128)
  // using one/more of the following Application Identifiers (AI)
  // 
  // scan argument enters a map with 'barcode' = '1254..54654' (current barcode scan)
  // and exits with all seen elements, like 'sscs', 'expr', etc.
  //
  decipherBarcode(scan){
    var reg_sscs =      /^00\d{18}/,                     // BSSCS
    reg_gtin14 =        /^01\d{14}/,                     // GTIN-14
    reg_ean14 =         /^02\d{14}/,                     // EAN14 + nbr of containers
    reg_batchnbr =      /^10(.{1,20})/,                  // batchnr
    reg_prod =          /^11\d{6}/,	                     // Production Date	6 digits: YYMMDD
    reg_pkg =           /^13\d{6}/,	                     // Packaging Date	6 digits: YYMMDD
    reg_sell =          /^15\d{6}/,	                     // Sell by Date (Quality Control)	6 digits: YYMMDD
    reg_expr =          /^17\d{6}/,	                     // Expiration Date	6 digits: YYMMDD
    reg_var =           /^20\d{2}/,	                     // Product Variant	2 digits
    reg_ser =           /^21.{1,20}/,	                   // Serial Number	1-20 alphanumeric
    reg_hibcc =         /^22.{1,29}/,	                   // HIBCC Quantity, Date, Batch and Link	1-29 alphanumeric
    reg_let =           /^23x.{1,19}/,                   // Lot Number	1-19 alphanumeric
    reg_add_prod_info = /^240.{1,30}/,                   // Additional Product Identification	1-30 alphanumeric
    reg_part_nbr =      /^241\d{3}.{1,30}/,              // Customer Part Number	N3+X..30
    reg_to_order =      /^242\d{3}\d{1,6}/,              // 242 Made-to-Order variation no	N3+N..6
    reg_pkg_comp =      /^243\d{3}.{1,20}/,              // Packaging Component Number	N3+X..20
    reg_ser_nbr2 =      /^250\d{3}.{1,30}/,              // Secondary Serial Number	N3+X..30
    reg_ref =           /^251\d{3}.{1,30}/,              // Reference to source entity	N3+X..30
    reg_doc_type =      /^253\d{3}\d{13}.{1,17}/,        // Global Document Type Identifier	N3+N13+X..17
    reg_compt =         /^254\d{3}.{1,20}/,              // GLN extension component	N3+X..20
    reg_coupon =        /^255\d{3}\d{13}.{1,12}/,        // Global Coupon Number	N3+N13+N..12
    // 30	    Quantity Each	–
    reg_weight =        /^310y\d{6}/,                     // Product Net Weight in kg	6 digits
    // 311y	  Product Length/1st Dimension, in meters	6 digits
    // 312y	  Product Width/Diameter/2nd Dimension, in meters	6 digits
    // 313y	  Product Depth/Thickness/3rd Dimension, in meters	6 digits
    // 314y	  Product Area, in square meters	6 digits
    // 315y	  Product Volume, in liters	6 digits
    // 316y	  product Volume, in cubic meters	6 digits
    // 320y	  Product Net Weight, in pounds	6 digits
    // 321y	  Product Length/1st Dimension, in inches	6 digits
    // 322y	  Product Length/1st Dimension, in feet	6 digits
    // 323y	  Product Length/1st Dimension, in yards	6 digits
    // 324y	  Product Width/Diameter/2nd Dimension, in inches	6 digits
    // 325y	  Product Width/Diameter/2nd Dimension, in feet	6 digits
    // 326y	  Product Width/Diameter/2nd Dimension, in yards	6 digits
    // 327y	  Product Depth/Thickness/3rd Dimension, in inches	6 digits
    // 328y	  Product Depth/Thickness/3rd Dimension, in feet	6 digits
    // 329y	  Product Depth/Thickness/3rd Dimension, in yards	6 digits
    // 330y	  Container Gross Weight (Kg)	6 digits
    // 331y	  Container Length/1st Dimension (Meters)	6 digits
    // 332y	  Container Width/Diameter/2nd Dimension (Meters)	6 digits
    // 333y	  Container Depth/Thickness/3rd Dimension (Meters)	6 digits
    // 334y	  Container Area (Square Meters)	6 digits
    // 335y	  Container Gross Volume (Liters)	6 digits
    // 336y	  Container Gross Volume (Cubic Meters)	6 digits
    // 340y	  Container Gross Weight (Pounds)	6 digits
    // 341y	  Container Length/1st Dimension, in inches	6 digits
    // 342y	  Container Length/1st Dimension, in feet	6 digits
    // 343y	  Container Length/1st Dimension in, in yards	6 digits
    // 344y	  Container Width/Diamater/2nd Dimension, in inches	6 digits
    // 345y	  Container Width/Diameter/2nd Dimension, in feet	6 digits
    // 346y	  Container Width/Diameter/2nd Dimension, in yards	6 digits
    // 347y	  Container Depth/Thickness/Height/3rd Dimension, in inches	6 digits
    // 348y	  Container Depth/Thickness/Height/3rd Dimension, in feet	6 digits
    // 349y	  Container Depth/Thickness/Height/3rd Dimension, in yards	6 digits
    // 350y	  Product Area (Square Inches)	6 digits
    // 351y	  Product Area (Square Feet)	6 digits
    // 352y	  Product Area (Square Yards)	6 digits
    // 353y	  Container Area (Square Inches)	6 digits
    // 354y	  Container Area (Square Feet)	6 digits
    // 355y	  Container Area (Suqare Yards)	6 digits
    // 356y	  Net Weight (Troy Ounces)	6 digits
    // 360y	  Product Volume (Quarts)	6 digits
    // 361y	  Product Volume (Gallons)	6 digits
    // 362y	  Container Gross Volume (Quarts)	6 digits
    // 363y	  Container Gross Volume (Gallons)	6 digits
    // 364y	  Product Volume (Cubic Inches)	6 digits
    // 365y	  Product Volume (Cubic Feet)	6 digits
    // 366y	  Product Volume (Cubic Yards)	6 digits
    // 367y	  Container Gross Volume (Cubic Inches)	6 digits
    // 368y	  Container Gross Volume (Cubic Feet)	6 digits
    // 369y	  Container Gross Volume (Cubic Yards)	6 digits    
    reg_nbrcont =       /^37\d{1,8}/,                    // Number of Units Contained	1-8 digits
    // 400	  Customer Purchase Order Number	1-29 alphanumeric
    // 410	  Ship To/Deliver To Location Code (EAN13 or DUNS code)	13 digits
    // 411	  Bill To/Invoice Location Code (EAN13 or DUNS code)	13 digits
    // 412	  Purchase From Location Code (EAN13 or DUNS code)	13 digits
    // 420	  Ship To/Deliver To Postal Code (Single Postal Authority)	1-9 alphanumeric
    // 421	  Ship To/Deliver To Postal Code (Multiple Postal Authority)	4-12 alphanumeric
    // 8001	  Roll Products – Width/Length/Core Diameter	14 digits
    // 8002	  Electronic Serial Number (ESN) for Cellular Phone	1-20 alphanumeric
    // 8003	  UPC/EAN Number and Serial Number of Returnable Asset	14 Digit UPC +1-16 Alphanumeric Serial Number
    // 8004	  UPC/EAN Serial Identification	1-30 Alphanumeric
    // 8005	  Price per Unit of Measure	6 digits
    // 8100	  Coupon Extended Code: Number System and Offer	6 digits – numeric
    // 8101	  8101 Coupon Extended Code: Number System, Offer, End of Offer	10 digits – numeric
    // 8102	  Coupon Extended Code: Number System preceded by 0	2 digits – numeric
    // 90	    Mutually Agreed Between Trading Partners	1-30 alphanumeric    
    // reg_priv =          /^9[1|2|3|4|5|6|7|8|9].{1,30}/   // Company Internal Information	1-30 alphanumeric
    reg_location =          /^91.{1,30}/   // Company Internal Information	1-30 alphanumeric
    
    let i=0
    scan.set( 'left', scan.get('barcode') )
    // this.barcodeTarget.innerText = scan.get('barcode')
    while(scan.get('left').length > 0){
      i++
      switch(true){
        case reg_sscs.test(scan.get('left')):     this.setScan( scan, 'sscs',     2, 20 ); break;
        case reg_gtin14.test(scan.get('left')):   this.setScan( scan, 'gtin14',   2, 16 ); break;
        case reg_ean14.test(scan.get('left')):    this.setScan( scan, 'ean14',    2, 16 ); break;
        case reg_batchnbr.test(scan.get('left')): this.setScan( scan, 'batchnbr', 2, 0 ); break;
        case reg_prod.test(scan.get('left')):     this.setScan( scan, 'prod',     2, 8 ); break;
        case reg_pkg.test(scan.get('left')):      this.setScan( scan, 'pkg',      2, 8 ); break;
        case reg_sell.test(scan.get('left')):     this.setScan( scan, 'sell',     2, 8 ); break;
        case reg_expr.test(scan.get('left')):     this.setScan( scan, 'expr',     2, 8 ); break;
        case reg_var.test(scan.get('left')):      this.setScan( scan, 'var',      2, 8 ); break;
        case reg_nbrcont.test(scan.get('left')):  this.setScan( scan, 'nbrcont',  2, 8); break;
        // case reg_priv.test(scan.get('left')):     this.setScan( scan, 'location',     2, 0); break;
        case reg_location.test(scan.get('left')): this.setScan( scan, 'location', 2, 0); break;
      }
      // failsafe ! Just in case we don't get a hit on all scan elements
      if(i > 10) return scan 
    }
    this.setTypes(scan)
    return scan
  }

  // based on the type of scan 
  //
  // product = <span class="material-symbols-outlined">bento</span>
  // pallet = <span class="material-symbols-outlined">inventory_2</span>
  // location = <span class="material-symbols-outlined">pin_drop</span>
  setIcon(types){
    var reg_sscs = /sscs/,
        reg_ean14 = /ean14/,
        reg_location = /location/

    switch(true){
      case reg_sscs.test(types):     this.greenIcon(this.barcodeIconSSCSTarget); break;
      case reg_ean14.test(types):    this.greenIcon(this.barcodeIconEAN14Target); break;
      case reg_location.test(types): this.greenIcon(this.barcodeIconLOCTarget); break;
    }
  }

  //
  // each subscan (key) gets listed
  // except barcode and left keys
  //
  setTypes(scan){
    let types=""; 
    scan.forEach( (v,k) => types += 'barcode left'.includes(k) ? '' : `${k}, ` )
    this.setIcon(types)
  }
  
  setScan( scan, type, start, size ){
    if (size < 1){
      scan.set(type, scan.get('left').slice(start) );     
      scan.set( 'left', '');
    } else {
      scan.set(type, scan.get('left').slice(start,size));     
      scan.set('left', scan.get('left').slice(size));
    }
  }

  //
  // prepScanset either adds a new scan tuple to the scanset
  // or finishes/updates last added scan tuple - new ones get 
  // put in front
  //
  // scan enters with all seen elements
  //
  prepScanset(scan){
    let insertNewScanTuple = (this.scanset.length < 1)
    // what is the current scan?
    switch(true){
      case scan.has('sscs'):      return( this.setSSCS(scan,insertNewScanTuple)); break;
      case scan.has('ean14'):     return( this.setProduct(scan,insertNewScanTuple)); break;
      case scan.has('location'):  return( this.setLocation(scan,insertNewScanTuple)); break;
    }
    this.setPostStatus()
    return false;
  }

  // setSSCS adds a pallet barcode to either a new tuple or the first tuple with no pallet barcode
  //
  setSSCS(scan,insertNewScanTuple){
    if (insertNewScanTuple && !this.shouldReload){
      this.scanset.unshift(scan)
      // this.tellMap(this.scanset[0], 'setSSCS new')
    } else {
      let processedQueue = [],
          processingScan = scan,
          map = null

      // first tuple without SSCS
      while( typeof (map = this.scanset.shift()) !== 'undefined' ) {
        if ( processingScan !== null && !map.has('sscs') ){
          this.tellMap(map, 'existing scanset tuple')
          processingScan.forEach( (v,i) => { if ( !map.has(i) ) map.set(i, v) })
          map.set( 'barcode', map.get('barcode') + ` ${processingScan.get('barcode')}`)
          processingScan = null
        } else {
          processedQueue.push(processingScan)
        }
        processedQueue.push(map)
      }
      this.scanset = processedQueue
      // this.tellMap(this.scanset[0],`setSSCS existing `)
    }
    var txt = `<p>SSCS ${scan.get('sscs')}</p><p>serie/batch ${scan.get('batchnbr')} </p>`
    this.totalScans = this.scanset.length
    this.scansetCountTarget.innerText = this.totalScans
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
  setProduct(scan,insertNewScanTuple){
    if (insertNewScanTuple && !this.shouldReload){
      this.scanset.unshift(scan)
      this.tellMap(this.scanset[0], 'setProduct new')
    } else {
      for (const entry in this.scanset){
        if (!this.scanset[entry].has('ean14')){
          scan.forEach( (v,i) => { if ( !this.scanset[entry].has(i) ) this.scanset[entry].set(i, v)  })
          this.scanset[entry].set( 'barcode', this.scanset[entry].get('barcode') + ` ${scan.get('barcode')}`)
        }
        this.tellMap(this.scanset[entry], `setProduct existing ${entry}`)
      }
    }
    var txt = `<p>ean14 ${scan.get('ean14')}</p><p> bedst inden ${scan.get('sell')}</p><p>antal kolli ${scan.get('nbrcont')}</p>`
    this.barcodeTextEAN14Target.innerHTML = txt    
    return true;
  }
  
  setLocation(scan,insertNewScanTuple){
    if (insertNewScanTuple && !this.shouldReload){
      this.scanset.unshift(scan)
      this.tellMap(this.scanset[0], 'setLocation new')
    } else {
      for (const entry in this.scanset){
        if (!this.scanset[entry].has('location')){
          scan.forEach( (v,i) => { if ( !this.scanset[entry].has(i) ) this.scanset[entry].set(i, v)  })
          this.scanset[entry].set( 'barcode', this.scanset[entry].get('barcode') + ` ${scan.get('barcode')}`)
        }
        this.tellMap(this.scanset[entry], `setLocation existing ${entry}`)
      }
    }
    this.barcodeTextLOCTarget.innerHTML = scan.get('barcode')
    return true;
  }

  tellMap(map, from){
    console.log(`Show Map ${from}-${this.scanset.length}---------------------------`)
    map.forEach( (v,i) => { console.log(`${i}: ${v} `)})
    console.log('Show Map ------------------------------ done')
  }

  handleMessages(e){
    // console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
  }
}
