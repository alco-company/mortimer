import { Controller } from "@hotwired/stimulus"

export default class ListController extends Controller {
  static values = {
    url: String,        // /suppliers/lookup
    cursorPosition: Number,
    listAwaitingFocus: Boolean,
    formAwaitingFocus: Boolean
  }

  initialize() {
    this.cursorPositionValue = 1
    this.listAwaitingFocus = false
    this.formAwaitingFocus = false
  }

  connect() {
    this.element[this.identifier] = this
    super.connect()
    this.focusList()
  }

  decrement_cursor(step=1){
    let rows = this.element.querySelectorAll("input[type=checkbox]").length - step
    this.cursorPositionValue = this.cursorPositionValue - step
    if (step === 1000 ) this.cursorPositionValue = 0
    if (this.cursorPositionValue < 0) this.cursorPositionValue = rows 
  }

  increment_cursor(step=1) {
    let rows = this.element.querySelectorAll("input[type=checkbox]").length - 1
    this.cursorPositionValue = this.cursorPositionValue + step
    if (this.cursorPositionValue > rows) this.cursorPositionValue = 1 
  }

  focusList(){
    document.getElementById("form-sleeve").classList.add("hidden")
    try{
      console.log(this.element.querySelectorAll("input[type=checkbox]")[this.cursorPositionValue])
      this.element.querySelectorAll("input[type=checkbox]")[this.cursorPositionValue].focus()
    } catch( err ){
      this.element.querySelectorAll("#toggle-all-rows")[0].focus()
    }
    console.log('focusing')
  }

  // we got the ok from authorization - now open the form
  focusForm(){
    console.log('focusForm')

    if (this.formAwaitingFocus){
      console.log('will ask someone to show the window...')
      window.dispatchEvent( new CustomEvent("speicherMessage", {
        detail: {
          message: 'open form'
        }
      }));  
      this.formAwaitingFocus = false
    }
  }
  
  async getData(url){
    let params = new URLSearchParams()

    Turbo.visit(url)
    this.listAwaitingFocus = true
    this.formAwaitingFocus = true
  }

  newForm(url){
    this.getData(`${url}`)
    console.log(url)
    this.formAwaitingFocus = true
  }
  
  openForm(id){
    if (id !== 'new'){
      id = `${id}/edit`
    }
    this.getData(`${this.urlValue}/${id}`)
  }
  
  openModalForm(){
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'open ui-modal'
      }
    }));    
    this.listAwaitingFocus = true
  }

  //
  // we'll handle Escape, Enter, ' ', Home, End, ArrowUp, ArrowDown, and Tab
  // and ordinary letters a-z as well
  //
  keyupHandler(e){
  }

  keydownHandler(e){    
    e.cancelBubble = true;
    if( e.stopPropagation ) e.stopPropagation();

    switch(e.key){
      // console.log("up " + e.key);
      // if (e.key === 'Escape') {
      //     this.hideOptions()
      //     return
      // }
      case 'ArrowUp': this.decrement_cursor(); this.focusList(); break;

      case 'ArrowDown': this.increment_cursor(); this.focusList(); break;
  
      // TODO: fetch previous page instead
      case 'PageUp': this.decrement_cursor(10); this.focusList(); break;

      // TODO: fetch next page instead
      case 'PageDown': this.increment_cursor(10); this.focusList(); break;

      case 'Home': this.cursorPositionValue = 1; this.focusList(); break;

      case 'End': 
        this.cursorPositionValue = this.element.querySelectorAll("input[type=checkbox]:not(#toggle-all-rows):not(.flags)").length
        this.focusList()
        break;

      case 'd':
      case 'D':
      case 'Delete':
        this.listAwaitingFocus = true
        this.deleteItems(e)
        break;
        
      case ' ':
        console.log(`space: ${e.key}`)
        // window.dispatchEvent( new CustomEvent("speicherMessage", {
        //   detail: {
        //     message: 'tap item',
        //     event: e
        //   }
        // }));    
        break;
      
      case 'f':
      case 'F':
        this.flagItems(e)
        break;
  
      case 'n':
      case 'N':
      case '+': this.cursorPositionValue = this.cursorPositionValue + 1; this.openForm('new'); break;

      case 'e':
      case 'E':
      case 'Enter': 
        e.preventDefault()
        this.openForm(e.srcElement.id.split("_")[ e.srcElement.id.split("_").length - 2])
        break;
  
      default: console.log(`down ${e.key}`); break;

    }
  }

  deleteItems(e){
    let ids = []
    if(e.srcElement.checked || e.srcElement.tagName === 'svg'){
      let elems = this.element.querySelectorAll("input[type=checkbox]:not(#toggle-all-rows):not(.flags)")
      elems.forEach(elem => {
        if(elem.checked){
          ids.push( elem.id.split("_")[ elem.id.split("_").length - 2] )
        }
      });
      console.log( ids )
      this.getData(`${this.urlValue}/modal?ids=${ids.join(',')}&action_content=delete`)
      this.openModalForm()
    } else {
      console.log(`deleting only one item: ${e.srcElement.id.split("_")[ e.srcElement.id.split("_").length - 2]}`)
      ids=e.srcElement.id.split("_")[ e.srcElement.id.split("_").length - 2]
      this.getData(`${this.urlValue}/modal?ids=${ids}&action_content=delete`)
      this.openModalForm()
    }
  }

  flagItems(e){
    window.dispatchEvent( new CustomEvent("speicherMessage", {
      detail: {
        message: 'set flag',
        event: e
      }
    }));    
  }

  handleMessages(e){
    console.log(`an event ${e} with ${e.detail.message} was received in ${this.identifier}`)

    if(e.detail.message==='authorization'){
      console.log('answering')
      if ( Number(e.detail.value)==Number(200) ){
        console.log('200 is ok!')
        this.focusForm()
      }
    }

    if(e.detail.message==='Submitted' && e.detail.sender==='form'){
      history.back()
      this.focusList()
    }

    if(e.detail.message==='Escape' && e.detail.sender==='form'){
      history.back() 
      this.focusList()
    }

    if(e.detail.message==='focus form'){
      this.focusForm()
    }

    if(e.detail.message==='focus list'){
      this.focusList()
    }

    if(e.detail.message==='new form'){
        this.newForm(e.detail.value)
    }

    if(e.detail.message==='delete item'){
      this.listAwaitingFocus = true
      this.deleteItems(e.detail.event)
    }
    if(e.detail.message==='refocus cursor_position'){
      if ( this.listAwaitingFocus === true ){
        if (e.detail.sender === 'ui-modal') {
          try{
            document.getElementById('modal_content').innerHTML=""
            document.getElementById('action-buttons').classList.add('hidden')
          } catch(e){
          }
          this.decrement_cursor(1000)
        }
        if(this.cursorPositionValue===1) this.cursorPositionValue=0
        this.focusList()
        this.listAwaitingFocus = false
      }
    }
  }
}
