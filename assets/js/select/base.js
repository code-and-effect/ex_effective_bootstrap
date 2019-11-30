import $ from "jquery"
import "./bootstrap-select.min"

export default class Select {
  initialize($element, options) {
    $element.selectpicker(options);
  }
}

$.fn.selectpicker.Constructor.BootstrapVersion = '4';

$(document).on('change', 'select.initialized', function(event) {
  window.EffectiveForm.validateSelect($(event.currentTarget));
});
