import "./bootstrap-select.js"

export default class Select {
  initialize($element, options) {
    $element.selectpicker(options);
  }
}

$(document).on('change', 'select.initialized', function(event) {
  if($(event.currentTarget).closest('form').hasClass('was-validated')) {
    window.EffectiveForm.validateSelect($(event.currentTarget));
  }
});
