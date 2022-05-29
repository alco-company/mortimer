import { Controller } from "@hotwired/stimulus"

export default class SwitchboardController extends Controller {
  static targets = [ "menu", "notifications", "profile", "unauthorized" ]

  connect() {
    super.connect()
    document.documentElement.addEventListener("turbo:before-fetch-response", function (e){
      // window.dispatchEvent( new CustomEvent("speicherMessage", { detail: { message: 'authorization', value: e.detail.fetchResponse.response.status }}) )
    })
  }
  
  toggleUserMenu() {
    // this.element.desktopComponent.toggle()
    this.element.mobileComponent.toggle()

    window.dispatchEvent( new CustomEvent("switchboardMessage", {
      detail: {
        event: 'toggleUserMenu'
      }
    }));
  }

  newForm(e){
    this.element.formSleeve.toggle()
    // window.dispatchEvent( new CustomEvent("speicherMessage", { detail: { message: 'new form', value: e.params.url }}) )
  }


  //
  // callable because of this snippet sitting in the connect method
  // on the extendedSlideover
  //
  // document.querySelector('#switchboard')[
  //   (str => {
  //   return str
  //     .split('--')
  //     .slice(-1)[0]
  //     .split(/[-_]/)
  //     .map(w => w.replace(/./, m => m.toUpperCase()))
  //     .join('')
  //     .replace(/^\w/, c => c.toLowerCase())
  //   })(this.identifier)] = this;

  // not used
  toggleFormSleeve() {
    // this.element.formSleeve.toggle()
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'open form'
      }
    }));  
}

  //
  // the most important job of the switchBoard controller is to
  // make sure messages are forwarded to whatever
  //
  // on the sending end do this:
  // window.dispatchEvent( new CustomEvent("what-to-do"))
  //
  // on the receiving end, define this in your HTML:
  // data-action="what-to-do@window->map#whatToDo"
  //
  // in case you need to add more data
  // window.dispatchEvent( new CustomEvent("what-to-do"){ detail: { message: 'some message or data'}} )
  //

  handleMessages(e){
    // if(e.detail.message==='open modal'){
    //   console.log('speicherMessage: open modal received')
    // }
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)
    // if(e.detail.message==='Escape'){
    //   if(e.detail.sender==='form'){
    //     // window.dispatchEvent( new CustomEvent("speicherMessage", {
    //     //   detail: {
    //     //     message: 'close slideover'
    //     //   }
    //     // }));    
    //     this.toggleFormSleeve()
    //     window.dispatchEvent( new CustomEvent("speicherMessage", {
    //       detail: {
    //         message: 'focus list'
    //       }
    //     }));    
    //   }
    // }
  }
}
