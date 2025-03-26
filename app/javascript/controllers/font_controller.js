import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  changeFont() {
    const selectedFont = this.selectTarget.value;
    document.documentElement.style.setProperty("--custom-font", selectedFont);
    localStorage.setItem("selectedFont", selectedFont);
  }
}
