// QueueWorker
// 
// This Worker provides a queue function 
// persisting data locally for shorter periods of time 
// until network connection can be (re)established 
//
// It provides a queue to send data to,
// accepts a url to forward data to,
// and an API to ask for status on the progress
// of the forwarding, as well as API's for
// stopping and (re)starting the queue
// 

let version = "1";
let employeeId = "1";
let queue = [];
let loadOnDone = false;

let timerInterval = null;
let timerTimeout = 120000; // every 2 minuts

let queueState = "stopped";

let urlMethod = "POST";
let urlUrl = "";
let csrfToken = null;
let urlHeaders = "";
let apiKey = "";

let heartbeatUrl = "";
let heartbeatTimerTimeout = 3600000; //every 60 minuts

function reportError({ message : m, data : d, error: e }) {
  console.log( `ERROR! The message ${m} was sent with data: ${d} with the following error: ${e}`)
}


// heartbeat 
// sends a heartbeat every heartbeatTimerTimeout
//
// on error it sets the link to down
//
function heartbeat() {
  fetch(`${heartbeatUrl}?api_key=${apiKey}`)
  .then(response => response.json())
  .then(data => {
    try{
      switch(true){
        case (data.version.toString() !== version):   postMessage( {reload: true} ); break;
        case (data.id.toString() == employeeId):         postMessage( {link_up: true} ); break;
        default:                                      postMessage( {link_down: true} ); break;
      }
      setTimeout( () => { this.heartbeat() }, heartbeatTimerTimeout)
    } catch(err){ reportError( { message: 'heartbeat', data: '', error: err} ) }
  })
  .catch( err => { 
    reportError( { message: 'heartbeat', data: '', error: err} ) 
    postMessage({link_down: true});  
    setTimeout( () => { this.heartbeat() }, heartbeatTimerTimeout)
  })
}

// postQueueTransaction
// transmits the transactions
// and possibly (if told so in the result) asks 
// the terminal to reload 
//
// on error it unshifts the data back on the queue
//
function postQueueTransaction(url, method, headers, data, queueData){
  try{
    options = {
      method: method,
      // mode: 'no-cors',
      // cache: 'no-cache',
      credentials: 'same-origin',
      headers: headers,
      body: JSON.stringify(data)
    }
  
    fetch(url, options)
    .then( response => {
      postMessage({ post: response.status }); 
      switch(response.status){
        case 200:
        case '200': 
        case 201: 
        case '201': if (loadOnDone && (queue.length < 1)) postMessage({ reloadnow: true }); return true; 
        default:  queue.unshift(queueData); return false; 
      }
    } )
  } catch (err) {
    postMessage({ response: "HI " + err }); return false;
  }
}

// 
// pull from the queue and send data off
// do this max 5 times
//
function pullQueueData(){
  i=0,data=null
  while(i<5){
    data = (queue.length > 0) ? queue.shift() : null
    if (data){
      url = `${urlUrl}?api_key=${apiKey}`
      post_data = {}
      data.forEach( (v,k) => post_data[k]=v ) 
      postQueueTransaction(url, urlMethod, urlHeaders, { task_transaction: post_data }, data)
      postMessage({ queueSize: queue.length }); 
    } else { i=5 }
    i++; data=null
  }
}

// stopQueue
// stops the queue 
//
function stopQueue() {
  try{
    clearInterval(timerInterval);
    timerInterval = null;
  } catch(err){
    reportError({ message: "cmd", data: "stop", error: err })
  }
  queueState = "stopped";
}

// statusQueue
// reports on the status of the queue
//
function statusQueue(){
  try{
    queue_status = timerInterval ? 'and is running' : 'but is not running!';
    items = (queue.length < 1) ? 'no' : queue.length;
    postMessage({ response: `Queue has ${ items } items - ${ queue_status }`});
  } catch(err) {
    reportError({ message: "cmd", data: "status", error: err })
  }
}

// startQueue
// starts the queue
//
function startQueue(){
  try{
    if (!timerInterval && (queueState !== 'started')){
      if ( timerTimeout / timerTimeout == 1) {        
        timerInterval = setInterval( function(){ pullQueueData() }, timerTimeout )
        queueState = "started";
      }
    }
  } catch(err) {
    queueState = "stopped";
    reportError({ message: "cmd", data: "start", error: err })
  }
}

// processCmd 
// interface for the queue ops
//
function processCmd(event){
  switch(event.data["cmd"]){
    case "start": startQueue(); break;
    case "status": statusQueue(); break;
    case "stop": stopQueue(); break;
    default: reportError( { message: "cmd", data: event.data, error: "Command unknown!" } ); 
  }
  return
}

// processData 
// interface for pushing data onto the queue
//
function processData(event){
  try {
    queue.push( event.data["data"] );
    postMessage( { queueSize: queue.length } )
  } catch(err){
    reportError( { message: "data", data: event.data, error: err })
  }
}

// say 
// build str from obj[]
//
function say(obj){
  str = ""; 
  for (k in obj) { 
    str += `${k}: ${obj[k]} ` 
  }
  return str 
}

//
// event state-machine
// handling messages from main
//
// usually you will send messages in this order:
//
// let msg = { url: "", frequency: 10000, heartbeat_url: "", heartbeat_frequency: 600000, cmd: "start" }
// postMessage(msg)
//
// you cannot send message setting any configurations and data - first send configuration and possibly 'start'
// then start sending data
//
onmessage = function(event) {
  switch(true){
    case event.data.hasOwnProperty('url'):                 urlUrl = event.data['url']
    case event.data.hasOwnProperty('method'):              urlMethod = event.data['method'] 
    case event.data.hasOwnProperty('frequency'):           timerTimeout = Number( event.data["frequency"] );
    case event.data.hasOwnProperty('headers'):             urlHeaders = event.data['headers']; urlHeaders = JSON.parse(urlHeaders);
    case event.data.hasOwnProperty('csrf'):                csrfToken = event.data['csrf']; urlHeaders["X-CSRF-Token"]=csrfToken;
    case event.data.hasOwnProperty('api_key'):             apiKey = event.data["api_key"] 
    case event.data.hasOwnProperty('heartbeat_frequency'): heartbeatTimerTimeout = Number( event.data["heartbeat_frequency"] ); 
    case event.data.hasOwnProperty('heartbeat_url'):       heartbeatUrl = event.data["heartbeat_url"]; heartbeat();
    case event.data.hasOwnProperty("employeeid"):          employeeId = event.data['employeeid']; console.log(employeeId);
    case event.data.hasOwnProperty('cmd'):                 processCmd(event); break;
    case event.data.hasOwnProperty('data'):                processData(event); break;
    case event.data.hasOwnProperty("link_down"):           postMessage( {link_down: true} ); break;
    case event.data.hasOwnProperty("link_up"):             postMessage( {link_up: true} ); break;
    case event.data.hasOwnProperty("reload"):              postMessage( {reload: true} ); break;
    case event.data.hasOwnProperty("loadondone"):          loadOnDone = true; break;
    case event.data.hasOwnProperty("version"):             version = event.data['version']; break;
  }
  // console.log(`this is the headers: ${say(urlHeaders)}`)
  
}
