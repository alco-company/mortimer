// 
// 2022/03/11 - walther h diechmann
// not working as expected as of now
//

import { Controller } from "@hotwired/stimulus"

export default class ContentLoaderController extends Controller {

  static values = { url: String, refreshInterval: Number, target: String }

  // connect() {
  //   this.load()

  //   if (this.hasRefreshIntervalValue) {
  //     this.startRefreshing()
  //   }
  // }
  
  disconnect() {
    this.stopRefreshing()
  }

  load({params}) {
    elem = document.getElementById(params.target)
    // console.log(elem)
    // fetch(this.urlValue)
    //   .then(response => response.text())
    //   .then(html => this.targetValue.innerHTML = html)
  }

  startRefreshing() {
    this.refreshTimer = setInterval(() => {
      this.load()
    }, this.refreshIntervalValue)
  }

  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }


  handleMessages(e){
    // console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
  }
  
}
