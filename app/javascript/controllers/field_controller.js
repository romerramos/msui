import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    original: String,
    index: Number
  }
  static outlets = [ "field" ]
  connect() {
  }

  check() {
    this.resetOthers()
    if (this.element.value != this.originalValue) {
      this.highlight()
    } else {
      this.reset()
    }
  }

  resetOthers() {
    this.fieldOutlets.forEach((fieldController) => {
      console.log(fieldController.indexValue)
      if (fieldController.indexValue != this.indexValue) {
        fieldController.reset()
      }
    })
  }

  highlight() {
    this.element.classList.remove('input-ghost')
    this.element.classList.add('input-accent')
  }

  reset() {
    this.element.value = this.originalValue
    this.element.classList.remove('input-accent')
    this.element.classList.add('input-ghost')
  }
}
