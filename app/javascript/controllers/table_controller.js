import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "newForm", "cancelRow", "add", "saveRow", "saveField", "cancelField", "field" ]
  static values = { fieldEditIndex: Number}

  addRow(){
    this.newFormTarget.classList.remove('hidden')
    this.cancelRowTarget.classList.remove('hidden')
    this.cancelFieldTarget.classList.add('hidden')
    this.addTarget.classList.add('hidden')
    this.saveRowTarget.classList.remove('hidden')
    this.saveFieldTarget.classList.add('hidden')
    this.resetOthers(0)
  }

  cancelRow(){
    this.newFormTarget.classList.add('hidden')
    this.newFormTarget.reset()
    this.cancelRowTarget.classList.add('hidden')
    this.addTarget.classList.remove('hidden')
    this.saveRowTarget.classList.add('hidden')
  }

  saveRow(){
    this.newFormTarget.requestSubmit()
  }

  cancelField(){
    this.saveFieldTarget.classList.add('hidden')
    this.cancelFieldTarget.classList.add('hidden')

    const fieldTarget = this.findFieldTarget(this.fieldEditIndexValue)
    this.resetField(fieldTarget)
    this.fieldEditIndexValue = 0
  }

  saveField(){
    const fieldTarget = this.findFieldTarget(this.fieldEditIndexValue)
    fieldTarget.form.requestSubmit()
  }

  resetOthers(index) {
    this.fieldTargets.forEach((fieldTarget) => {
      const currentIndex = fieldTarget.dataset.index
      if (currentIndex != index) {
        this.resetField(fieldTarget)
      }
    })
  }

  fieldEdit(e){
    const element = e.target
    const original = element.dataset.original
    const index = element.dataset.index

    this.saveFieldTarget.classList.remove('hidden')
    this.cancelFieldTarget.classList.remove('hidden')

    this.fieldEditIndexValue = index
    this.resetOthers(index)
    this.cancelRow()
    if(element.value != original) {
      this.highlightField(element)
    } else {
      this.resetField(element)
    }
  }

  highlightField(element) {
    element.classList.remove('input-ghost')
    element.classList.add('input-accent')
  }

  resetField(element) {
    element.value = element.dataset.original
    element.classList.remove('input-accent')
    element.classList.add('input-ghost')
  }

  findFieldTarget(index ) {
    return this.fieldTargets.filter(t => t.dataset.index == index)[0]
  }
}
