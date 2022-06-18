import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

const spinner = `
  <div class="col-span-12 container mx-auto h-24 mb-8" id="spinner">
    <div class="loader">Loading...</div>
  </div>`

export default class PaginationController extends Controller {

  static values = {
    url: String,
    page: { type: Number, default: 1 },
  };

  static targets = [ "noRecords", "pagy" ];

  connect() {
    const fetching = false; // debounce
  }

  // when the user scrolls the page - check if we're good to "go fetch"
  scroll() {
    if (this.#pageEnd && !this.fetching && !this.hasNoRecordsTarget) {
      this.#loadRecords();
    }
  }

  // send a TurboStream request to the controller for more records, plz
  async #loadRecords() {
    let next_url = this.pagyTarget.querySelector("a[rel='next']")
    if (!next_url)
      return 

    // Add the spinner at the end of the page
    this.pagyTarget.insertAdjacentHTML("beforeend", spinner);

    const url = new URL(next_url.href);
    url.searchParams.set("page",this.pageValue);

    this.fetching = true;

    await get(url.toString(), {
      responseKind: "turbo-stream",
    });

    // give the server just half a sec´ to return some data, will'ya?!
    setTimeout(() => this.fetching = false, 500)
    
    this.pageValue += 1;
  }

  // detect if we're at the end of the list of posts
  get #pageEnd() {
    var body = document.body,
        html = document.documentElement

    var height = Math.max( body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight )
    return (window.pageYOffset >= height - window.innerHeight - 100)
  }

}