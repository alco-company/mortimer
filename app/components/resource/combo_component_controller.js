import { Controller } from '@hotwired/stimulus'
import { get, post } from '@rails/request.js'

export default class ComboComponentController extends Controller {
    static targets = [ "input", "button", "tags", "select", "selectOptions" ]
    static values = {
        url: String,            // where to do the lookup for data values
        current: String,        // what is the current input value
        accountId: String,      // what is the current input value

        isSingle: Boolean,      // just one selectable item
        isMulti: Boolean,       // any number of selectable items
        isDrop: Boolean,        // ol'school drop down select
        isList: Boolean,        // even older school select list
        isTags: Boolean,        // show tags below an input
        isSearch: Boolean,      // can items be searched (provided a url is given)
        isAdd: Boolean,         // can new items be created
        apiKey: String,         // apiKey if component is used by 'non-user'
        apiClass: String,       // apiClass if component is used by 'non-user' - entity validating the apiKey

        selected: Array
    }

    connect() {
        super.connect()
        
        this.shouldUpdateInputValue = this.isDropValue //!(this.isAddValue || this.isSearchValue)
        if (this.isMultiValue){
            let select = this.selectTarget
            this.selectedValue = [...select.options]
            .filter(option => option.selected)
            .map(option => option.value)
        } else {
            this.selectedValue.push(this.selectTarget.value)
        }
        this.updateSelect()

        // console.log(`isSingle ${this.isSingleValue}`)
        // console.log(`isMulti ${this.isMultiValue}`)
        // console.log(`isDrop ${this.isDropValue}`)
        // console.log(`isList ${this.isListValue}`)
        // console.log(`isTags ${this.isTagsValue}`)
        // console.log(`isSearch ${this.isSearchValue}`)
        // console.log(`isAdd ${this.isAddValue}`)
        // console.log(`shouldUpdateList ${this.shouldUpdateInputValue}`)
    }

    inOut(e) {
        console.log('inOut')
    }

    keyupHandler(e){
        console.log(`keyupHandler ${this.inputTarget.value}`)
        this.currentValue = this.inputTarget.value 
        if (this.currentValue === '') {
            this.selectOptionsTarget.classList.add('hidden')
        }
    }

    keydownHandler(e){
        console.log(`keydownHandler ${this.inputTarget.value}`)
    } 

    // toggle show/hide an element
    toggleHidden(e){
        if (e.classList.contains('hidden')){
            e.classList.remove('hidden')
        } else {
            e.classList.add('hidden')
        }
    }

    // Stimulus method
    // will run whenever a keystroke in the input will change the content of that form control
    currentValueChanged(now, previous){
        console.log(`checking changed value ${now} ${previous}`)
        if( (now !== previous) && (now !== '') && (this.isSearchValue || this.isAddValue) ){
            console.log(` ${now} is different than ${previous}`)
            this.getData(now)
            this.selectOptionsTarget.classList.remove('hidden')
        }
    }

    // clicking the button on the right of the input form control
    clickIcon(e){
        this.toggleHidden(this.selectOptionsTarget)
    }

    // clicking any item in the list will select it
    async clickListItem(e){
        if (this.isAddValue && e.srcElement.dataset.recordId==0){
            post(this.urlValue, { 
                body: JSON.stringify({ role: {account_id: this.accountIdValue, name: e.srcElement.dataset.recordName, context: " ", role: [] } }),
                responseKind: "json"
            })
            .then(response => response.json)
            .then( data => {
                this.setOption(data.id)
                this.toggleHidden(e.srcElement.nextElementSibling)
                this.updateSelect(data.name)
                this.updateInputWithServerValues()
                this.updateList()
                if (!this.isListValue)
                    this.toggleHidden(this.selectOptionsTarget)    
            })
        } else {
            this.selectItem(e)
            if (!this.isListValue)
                this.toggleHidden(this.selectOptionsTarget)
        }
    }

    // when the user taps the 'x' on a tag in order to delete it
    removeTag(e){
        e.stopPropagation()
        try {            
            const id = e.path[2].dataset.id
            if (Number(id) > 0){
                this.setOption(id)
                this.toggleHidden(e.path[3])
                this.updateSelect()
                this.updateInputWithServerValues()
                this.updateList()
            }
        } catch (error) {
            console.error(`Error in removeTag - ${error}`)
        }
    }

    // when the user taps an item
    selectItem(e){
        this.setOption(e.srcElement.dataset.recordId)
        this.toggleHidden(e.srcElement.nextElementSibling)
        this.updateSelect(e.srcElement.dataset.recordName)
        this.updateInputWithServerValues()
        this.updateList()
    }

    // get lookup data for the list - fill'in using TurboStream
    getData(query=''){
        try {            
            if( (query=='*') || (query.length>1 && query !== '  ') ){
                let params = new URLSearchParams()
                params.append('stimulus_controller', 'resource--combo-component')
                params.append('stimulus_lookup_target', "selectOptions")
                params.append('lookup_target', this.selectOptionsTarget.id)
                params.append('values', this.selectedValue)
                params.append('add', this.isAddValue ? "true" : "false")
                params.append('q',query)
                if (query=="*")
                    params.append('items',50)
                
                get(`${this.urlValue}/lookup?${params}`, {
                    responseKind: "turbo-stream"
                })
            }
        } catch (error) {
            console.error(`Error in getData - ${error}`)
        }
    }

    // update the selectedValue array 
    setOption(id){
        try {            
            if (this.isMultiValue){
                if (this.selectedValue.includes(id)) {
                    this.selectedValue = this.selectedValue.filter( v => Number(v) != Number(id))
                } else {
                    this.selectedValue = [...this.selectedValue,String(id)]
                }
            } else {
                if (this.selectedValue.includes(id)) {
                    this.selectedValue = []
                } else {
                    this.selectedValue = [ id ]
                    this.selectTarget.value = id
                }
            }
        } catch (error) {
            console.error(`Error in setOption - ${error}`)
        }
    }

    // show the selected values in the input field if visible
    async updateInputWithServerValues(){
        try {            
            if (this.selectedValue.length > 0){
                // get the selected values
                let uri = this.selectedValue.join(',')
                let encoded = encodeURIComponent(uri)
                let apikey = this.apiKeyValue == '' ? '' : `&api_key=${this.apiKeyValue}&api_class=${this.apiClassValue}` 
                const response = await get(`${this.urlValue}?ids=${encoded}${apikey}`, { responseKind: "json" })
                if (response.ok){
                    const elems = await response.json
                    console.log(`got this back from the server ${elems}`)

                    const names = elems.map( e => e.name )
                    const tags = elems.map( e => [e.id,e.name])
                    this.updateInput(names)
                    if (this.isTagsValue)
                        this.updateTags(tags)
                }
            } else {
                this.updateInput([])
                this.updateTags([])
            }
        } catch (error) {
            console.error(`Error in updateInputWithServerValues - ${error}`)
        }
    }

    // update the list element
    updateList(){
        this.selectOptionsTarget.querySelectorAll('li span.absolute').forEach( e => {
            this.selectedValue.includes(e.previousElementSibling.dataset.recordId) ? e.classList.remove('hidden') : e.classList.add('hidden')
        })
    }

    // update the input form control
    //
    updateInput(values){
        console.log(`trying to updateInput with ${values} - but should I update? ${this.shouldUpdateInputValue}`)
        if ( this.shouldUpdateInputValue ) {
            try {            
                this.inputTarget.value = values.join(', ')
            } catch (error) {
                console.error(`Error in updateInput - or at least Input is missing (on purpose?) - ${error}`)
            }
        }
    }

    // update the list of tags
    //
    updateTags(tags){
        try{
            this.tagsTarget.innerHTML = ""
            tags.map( tag => {
                const elem = document.createElement("span");
                elem.classList.add('inline-flex', 'items-center', 'py-0.5', 'pl-2', 'pr-0.5', 'rounded-full', 'text-xs', 'font-medium', 'bg-indigo-100', 'text-indigo-700')
                elem.innerHTML = `<span class="">
                        ${tag[1]}
                        <button 
                            data-id="${tag[0]}"
                            type="button" class="flex-shrink-0 ml-0.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-indigo-400 hover:bg-indigo-200 hover:text-indigo-500 focus:outline-none focus:bg-indigo-500 focus:text-white">
                        <span class="sr-only">Remove small option</span>
                        <svg class="h-[8px] w-[8px]" stroke="currentColor" fill="none" viewBox="0 0 8 8">
                            <path stroke-linecap="round" stroke-width="1.5" d="M1 1l6 6m0-6L1 7" />
                        </svg>
                        </button>
                    </span>`
                this.tagsTarget.appendChild(elem);
            })
        } catch(err) {
            console.error(`Error in updateTags - ${error}`)
        }
    }

    // build the options for a select form control
    //
    updateSelect(name) {
        if (!this.isMultiValue)
            return
        try {
            this.selectTarget.innerHTML = "";
            if (this.selectedValue.length == 0) {
                //   const option = document.createElement("option");
                //   option.innerHTML = "no options";
                //   this.selectTarget.appendChild(option);
            } else {
                this.selectedValue.forEach((opt,i) => {
                const option = document.createElement("option");
                option.value = opt;
                option.selected = true
                option.innerHTML = opt==0 ? name : `option ${i}`
                this.selectTarget.appendChild(option);
              });
            }
        } catch (error) {            
            console.error(`Error in updateSelect - ${error}`)
        }
    }

}