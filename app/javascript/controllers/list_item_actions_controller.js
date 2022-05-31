import { Controller } from "@hotwired/stimulus"

export default class ListItemActionsController extends Controller {

  connect(){
    super.connect()
  }

  tap(e){
    this.toggleAllCheckBoxes(e)
  }

  tapDelete(e){
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'delete item',
        event: e
      }
    }));    
  }
  tapArchive(){
    console.log('tapArchive')
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'archive item',
      }
    }));    
    
  }
  tapShare(){
    console.log('tapShare')
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'share item',
      }
    }));    
    
  }
  tapFlag(e){
    console.log('tapFlag')
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'set flag',
        event: e
      }
    }));    
    
  }
  tapTask(){
    console.log('tapTask')
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'task item',
      }
    }));    
    
  }
  tapMove(){
    console.log('tapMove')
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'move item',
      }
    }));    
    
  }

  toggleAllCheckBoxes(e){
    let ids = []
    
    let i=0
    while(i < document.querySelectorAll("input[type=checkbox]:not(#toggle-all-rows):not(.flags)").length){
      let elem = document.querySelectorAll("input[type=checkbox]:not(#toggle-all-rows):not(.flags)")[i]
      if(e.srcElement.id==='toggle-all-rows'){  
        elem.checked = !elem.checked
      }
      if (elem.checked){
        ids.push( elem.id.split("_")[ elem.id.split("_").length - 2] )
      } 
      i = i +1
    }
    if (e.target.checked || (ids.length > 0) ){
      this.showActionButtons()
    } else {
      this.hideActionButtons()
    }

  }

  keydownHandler(e) {
    console.log(`list_item_actions ${e.key}`)
  }

  showActionButtons(){
    document.getElementById('action-buttons').classList.remove('hidden')
  }
  
  hideActionButtons(){
    document.getElementById('action-buttons').classList.add('hidden')
  }
  
  
  handleMessages(e) {
    // console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)

    if(e.detail.message==='tap item'){
      this.toggleAllCheckBoxes(e.detail.event)
    }
  }
}
