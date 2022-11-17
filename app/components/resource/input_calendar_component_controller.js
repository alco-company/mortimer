import { Controller } from "@hotwired/stimulus"
import { RRule, RRuleSet, rrulestr } from 'rrule'
import dayjs from 'dayjs'
import { Rule } from "postcss"

/*

the InputCalendarComponentController provides the necessary logic
to go with the UI, ie adding click handlers on U (all), M,T,W,T,F,S,S (weekdays)
and numbered weeks, and all 42 days

md[0-55] holds all rules -  
  0     = rules pertaining to all days
  1-7   = rules pertaining to all weekdays
  c % 8 = rules on weeks
  rest  = rules on a day

*/
export default class InputCalendarComponentController extends Controller {
  static targets = [ "input", "day", "weekday", "week", "month", "modal" ]
  
  static values = {
    rrule: String,
    dtstart: String,
    dtend: String
  }
  
  connect() {
    this.currentSelection=null
    this.currentIndex=null
    this.dtstart = dayjs(this.dtstartValue)
    this.dtend = dayjs(this.dtendValue)
    this.markedDays = [] // JSON.parse(this.inputTarget.value)
    this.md = [] // this.md[ t.dataset.rangeIndex ] = [ rule, rule ]
    this.setInitialRules()
  }
  
  setInitialRules(){
    let rules = []
    if (this.rruleValue) {
      rules = JSON.parse(this.rruleValue) // [ {id: 8, rrule: ''},...]
    }
    this.rrules = []
    if (rules.length > 0) {
      for ( const r of rules) { 
        let unix_dates = []
        let rrule = rrulestr(r.rrule)
        let udatos = rrule.between( this.dtstart.toDate(), this.dtend.toDate() )
        for (const d of udatos){ unix_dates.push( dayjs(d).endOf('day').unix() )} 
        this.rrules.push( {id: r.id, rrule: rrule, rrule_string: r.rrule, dates: unix_dates} ) 
      }
    }
    this.setMd()
  }

  on(t) {
    if (!t.classList.contains('bg-green-400'))
      t.classList.add('bg-green-400')
  }

  off(t){
    if (t.classList.contains('bg-green-400'))
      t.classList.remove('bg-green-400')
  }
  
  // flip(t,e){
  //   let hit = true
  //   if (t.classList.contains('bg-green-400')){
  //     t.classList.remove('bg-green-400')
  //     this.markedDays=this.markedDays.filter( d => Number(d) !== Number(t.dataset.rangeIndex) )      
  //     hit = false
  //   } else {
  //     t.classList.add('bg-green-400')
  //     this.markedDays.push(Number(t.dataset.rangeIndex))
  //     hit = true
  //   }
  //   this.markedDays=this.markedDays.filter( (v, i, a) => a.indexOf(v) === i ) 
  //   this.inputTarget.value = JSON.stringify(this.markedDays)
  //   return hit
  // }

  clearAll(e) {
    this.md = []
    this.rrules = []
    for (const t of this.dayTargets) { 
      let i = Number(t.dataset.rangeIndex)
      t.classList.remove('bg-green-400') 
    }
    // this.markedDays = []
    // this.inputTarget.value = JSON.stringify(this.markedDays)
  }

  setMd(){

    // look at every weekday in the calendar
    for (const t of this.weekdayTargets ){
      let i = Number(t.dataset.rangeIndex)
      for ( const r of this.rrules ) {
        if (r.dates.includes(dayjs(t.dataset.rangeDate).endOf('day').unix())) {
          this.md[i]=r
        }
      }
    }
    
    // look at every week in the calendar
    for (const t of this.weekTargets ){
      let i = Number(t.dataset.rangeIndex)
      for ( const r of this.rrules ) {
        if (r.dates.includes(dayjs(t.dataset.rangeDate).endOf('day').unix()) && r.rrule.options.count == 7) {
          this.md[i]=r
        }
      }
    }

    // look at every day in the calendar
    for (const t of this.dayTargets) {
      for ( const r of this.rrules ) {
        if (r.dates.includes(dayjs(t.dataset.rangeDate).endOf('day').unix())) {
          if (r.rrule.options.freq == RRule.DAILY) {
            this.md[ Number(t.dataset.rangeIndex) ]= r
          }
        }
      }
    }

    this.flipDays()

  }

  flipDays(){
    if (this.md[0]) {
      for (const t of this.dayTargets) { 
        this.on(t) 
      }
      return
    }
    for (const i of [1,2,3,4,5,6,7]){
      if (this.md[i]){
        for (const t of this.dayTargets) {
          if ((t.dataset.rangeIndex - i ) % 8 == 0) {
            this.on(t)
          }
        }
      }
    }
    for (const i of [8,16,24,32,40,48]){
      if (this.md[i]){
        for (const t of this.dayTargets) { 
          if ((t.dataset && t.dataset.rangeIndex && i) && 
              (!((t.dataset.rangeIndex-0) < i)) &&
              ((t.dataset.rangeIndex - i) < 8)
          ) this.on(t)
        }
      }
    }
    for (const t of this.dayTargets) { 
      if ( this.md[ Number(t.dataset.rangeIndex) ] )
        this.on(t)
    }
  }

  setRules(e,i){
    if (!e.dataset)
      return

    this.currentSelection = null
    let dtstart = dayjs(e.dataset.rangeDate).startOf('day').format('YYYYMMDDTHHmmss[Z]') 
    let dtend = null
    let rr = ''
    let unix_dates = []
    let rrule = new RRule()
    let udatos = []
    let r = {}

    switch(e.dataset.range){

      // 'DTSTART:20221031T064500Z\nRRULE:FREQ=DAILY;BYDAY=MO,TU,WE,TH,FR,SA,SU;INTERVAL=1;COUNT=42'
      case 'all': 
        dtend = this.dtend.endOf('day').format('YYYYMMDDTHHmmss[Z]') 
        rr = `DTSTART:${dtstart}\nRRULE:FREQ=DAILY;UNTIL=${dtend};INTERVAL=1`
        rrule = rrulestr(rr)
        udatos = rrule.between( this.dtstart.startOf('day').toDate(), this.dtend.endOf('day').toDate() )
        for (const d of udatos){ unix_dates.push( dayjs(d).endOf('day').unix() )} 
        this.rrules.push( {id: 0, rrule: rrule, rrule_string: rr, dates: unix_dates} ) 
        this.md[0] = 1
        break;

      // 'DTSTART:20221107T064500Z\nRRULE:FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU;INTERVAL=1;COUNT=7'
      //
      // 
      case 'week':
        rr = `DTSTART:${dtstart}\nRRULE:FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU;INTERVAL=1;COUNT=7`
        rrule = rrulestr(rr)
        udatos = rrule.between( this.dtstart.toDate(), this.dtend.toDate() )
        for (const d of udatos){ unix_dates.push( dayjs(d).endOf('day').unix() )} 
        this.rrules.push( {id: 0, rrule: rrule, rrule_string: rr, dates: unix_dates} ) 
        break;

      // 'DTSTART:20221031T064500Z\nRRULE:FREQ=WEEKLY;BYDAY=MO;INTERVAL=1;COUNT=6'
      case 'weekday':
        let weekday = ( [ '','MO','TU','WE','TH','FR','SA','SU' ][ i ])
        rr = `DTSTART:${dtstart}\nRRULE:FREQ=WEEKLY;BYDAY=${weekday};INTERVAL=1;COUNT=6`
        rrule = rrulestr(rr)
        udatos = rrule.between( this.dtstart.toDate(), this.dtend.toDate() )
        for (const d of udatos){ unix_dates.push( dayjs(d).endOf('day').unix() )} 
        this.rrules.push( {id: 0, rrule: rrule, rrule_string: rr, dates: unix_dates} ) 
        break;

      // 'DTSTART:20221031T064500Z\nRRULE:FREQ=DAILY;INTERVAL=1;COUNT=1'
      case 'day':
        rr = `DTSTART:${dtstart}\nRRULE:FREQ=DAILY;INTERVAL=1;COUNT=1`
        rrule = rrulestr(rr)
        udatos = rrule.between( this.dtstart.toDate(), this.dtend.toDate() )
        for (const d of udatos){ unix_dates.push( dayjs(d).endOf('day').unix() )} 
        this.rrules.push( {id: 0, rrule: rrule, rrule_string: rr, dates: unix_dates} ) 
        break;
      }

    this.setMd()

  }

  toggleAllDays(e){
    let t= e.target.closest('[data-range')
    let i = Number(t.dataset.rangeIndex)
    if (this.md[i]) {
      this.md[i] = null
      for (const t of this.dayTargets) {
        this.off(t)
      }    
    } else {
      this.md[i] = null
      this.currentSelection=t
      this.currentIndex=i
      this.modalTarget.classList.remove("hidden")
    }
  }

  toggleWeekDay(e){
    let t= e.target.closest('[data-range')
    let i = Number(t.dataset.rangeIndex)
    if (this.md[i] ) {
      this.md[i] = null
      for (const t of this.dayTargets) {
        if ((t.dataset.rangeIndex - i ) % 8 == 0) {
          this.off(t)
        }
      }    
    } else {
      this.md[i] = null
      this.currentSelection=t
      this.currentIndex=i
      this.modalTarget.classList.remove("hidden")
    }
  }

  toggleWeek(e){
    let t= e.target.closest('[data-range')
    let i = Number(t.dataset.rangeIndex)
    if (this.md[i] ) {
      this.md[i] = null
      for (const t of this.dayTargets) {
        if ((t.dataset && t.dataset.rangeIndex && i) && 
            (!((t.dataset.rangeIndex-0) < i)) &&
            ((t.dataset.rangeIndex - i) < 8)
        ) this.off(t)
      }    
    } else {
      this.md[i] = null
      this.currentSelection=t
      this.currentIndex=i
      this.modalTarget.classList.remove("hidden")
    }
  }

  toggleDay(e) {
    let t= e.target.closest('[data-range')
    let i = Number(t.dataset.rangeIndex)
    this.md[ i ] = null
    if (t.classList.contains('bg-green-400')){
      // TODO filter this.rrules on this.md[i]
      this.off(t)
      return 
    }
    this.currentSelection=t
    this.currentIndex=i
    this.modalTarget.classList.remove("hidden")
  }

  saveModal(e){
    this.modalTarget.classList.add("hidden")
    this.setRules(this.currentSelection, this.currentIndex)
  }
  
  cancelModal(e){
    this.modalTarget.classList.add("hidden")
    this.currentSelection=null
    this.currentIndex=null
    console.log(this.md)
  }

}
