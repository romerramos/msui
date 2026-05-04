import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "checkboxes", "form", "actions" ]

  check(e){
    if (e.target.checked) {
      this.actionsTarget.classList.remove('hidden')
    }
    const targets = this.checkboxesTargets.filter(t => !t.checked)
    if (targets.length == this.checkboxesTargets.length) {
      this.actionsTarget.classList.add('hidden')
    }
  }

  delete() {
    this.checkboxesTargets
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.dataset.pk)
      .forEach(pk => {
        const input = document.createElement("input")
        input.type = "hidden"
        input.name = "fields[pk_values][]"
        input.value = pk
        this.formTarget.appendChild(input)
      })
    this.formTarget.requestSubmit()
  }
}
