import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "newForm", "cancel", "add", "saveRow" ]
  connect() {
    console.log("Table controller connected", this.newFormTarget)
  }

  addRow(){
    this.newFormTarget.classList.remove('hidden')
    this.cancelTarget.classList.remove('hidden')
    this.addTarget.classList.add('hidden')
    this.saveRowTarget.classList.remove('hidden')
  }

  cancel(){
    this.newFormTarget.classList.add('hidden')
    this.newFormTarget.reset()
    this.cancelTarget.classList.add('hidden')
    this.addTarget.classList.remove('hidden')
    this.saveRowTarget.classList.add('hidden')
  }

  saveRow(){
    this.newFormTarget.requestSubmit()
  }
}
