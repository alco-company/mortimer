import { Controller } from "@hotwired/stimulus"

export default class InputCalendarComponentController extends Controller {
  static targets = [ "input", "day", "weekday", "week" ]

  connect() {
    this.markedDays = JSON.parse(this.inputTarget.value)
    this.markAllMarked()
  }
  
  flip(t){
    if (t.classList.contains('bg-green-400')){
      t.classList.remove('bg-green-400')
      this.markedDays=this.markedDays.filter( d => Number(d) !== Number(t.dataset.rangeIndex) )      
    } else {
      t.classList.add('bg-green-400')
      this.markedDays.push(Number(t.dataset.rangeIndex))
    }
    this.markedDays=this.markedDays.filter( (v, i, a) => a.indexOf(v) === i ) 
    this.inputTarget.value = JSON.stringify(this.markedDays)
  }

  clearAll(e) {
    for (const t of this.dayTargets) { t.classList.remove('bg-green-400') }
    this.markedDays = []
    this.inputTarget.value = JSON.stringify(this.markedDays)
  }

  markAllMarked(){
    for (const t of this.dayTargets) {
      if (this.markedDays.includes(Number(t.dataset.rangeIndex)))
        this.flip(t)
    }
  }

  flipDays(e){
    if (!e.dataset)
      return
    switch(e.dataset.range){
      case 'all': 
        for (const t of this.dayTargets) { this.flip(t) }
        break;
      case 'week':
        for (const t of this.dayTargets) { 
          if ((t.dataset && t.dataset.rangeIndex && e.dataset.rangeIndex) && 
              (!((t.dataset.rangeIndex-0) < (e.dataset.rangeIndex-0))) &&
              ((t.dataset.rangeIndex - e.dataset.rangeIndex) < 7)
          ) this.flip(t)
        }
        break;
      case 'weekday':
        for (const t of this.dayTargets) { if ((e.dataset.rangeIndex - t.dataset.rangeIndex) % 7 == 0) this.flip(t) }
        break;
      case 'day':
        this.flip(e)
        break;
    }
    // console.log(e.target.closest('[data-range').dataset.range)
  }


  toggleDay(e) {
    // e.preventDefault()
    //dirty hack !!!
    this.flipDays(e.target.closest('[data-range'))
  }

}
