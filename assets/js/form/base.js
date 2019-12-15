import TelephoneInput from "../telephone_input/base"
import Select from "../select/base"

const effective_inputs = {
  'telephone_input': TelephoneInput,
  'select': Select
}

export default class EffectiveForm {
  constructor() {
    this.currentSubmit = "";
  }

  good() { return "you good"; }

  initialize(target) {
    $(target || document).find('[data-input-js-options]:not(.initialized)').each(function (i, element) {
      let $element = $(element);
      let options = JSON.parse($element.attr('data-input-js-options'));

      let method_name = options['method_name'];
      delete options['method_name'];

      if (!effective_inputs[method_name]) {
        return console.error("EffectiveForm " + method_name + " has not been implemented");
      }

      let effective_input = new effective_inputs[method_name];
      effective_input.initialize($element, options);
      $element.addClass('initialized');
    });

    return true;
  }

  onSubmitClick(input) {
    this.currentSubmit = $(input);
    return true;
  }

  // All effective form submits will call this
  validate(form) {
    let valid = form.checkValidity();
    let $form = $(form);

    if (valid) { this.submitting($form); } else { this.invalidate($form); }

    return valid;
  }

  submitting($form) {
    $form.addClass('form-is-valid');
    $form.removeClass('form-is-invalid');

    this.disable($form);

    if ($form.attr('phx-submit')) {
      this.flashLiveViewSuccess();
    } else {
      this.flashSuccess();
    }

    return true;
  }

  // These controls need a little bit of help with client side validations
  validateSelect($select) {
    $select.each(function () {
      if ($(this).is('select:invalid')) {
        $(this).closest('.bootstrap-select').addClass('is-invalid').removeClass('is-valid');
      } else {
        $(this).closest('.bootstrap-select').addClass('is-valid').removeClass('is-invalid');
      }
    });
  }

  invalidate($form) {
    this.reset($form);

    $form.addClass('was-validated');
    $form.addClass('form-is-invalid');
    $form.find('.effective-current-submit').removeClass('.effective-current-submit');

    this.validateSelect($form.find('select.initialized'));

    this.flashError();
    return true;
  }

  spin($form) {
    this.currentSubmit.addClass('effective-current-submit');
    return true;
  }

  disable($form) {
    $form.find('[type=submit]').prop('disabled', true);
    return true;
  }

  reset($form) {
    // Reset the form
    $form.removeClass('was-validated');
    $form.removeClass('form-is-invalid');
    $form.removeClass('form-is-valid');

    // Reset the submit button
    $form.find('.effective-current-submit').removeClass('.effective-current-submit');
    $form.find('[type=submit]').removeAttr('disabled');

    // Server side validations
    $form.find('.alert.is-invalid').remove();
    $form.find('.is-invalid').removeClass('is-invalid');
    $form.find('.is-valid').removeClass('is-valid')

    return true;
  }

  flashSuccess() {
    this.flash('form-success', 1000, function () { window.EffectiveForm.flashSpin(); })
  }

  flashLiveViewSuccess() {
    this.flash('form-success', 0, function () { window.EffectiveForm.flash('form-success'); })
  }

  flashError() { this.flash('form-error', 1000) }
  flashSpin() { this.flash('spinner', 5000) }

  flash(name, delay = 1000, fun) {
    if (this.currentSubmit.length == 0) { return false; }

    return this.currentSubmit
      .addClass('effective-current-submit')
      .find('.eb-icon-' + name).show()
      .delay(delay)
      .fadeOut('slow', function () {
        $('.effective-current-submit').removeClass('effective-current-submit');
        if (fun) { fun(); }
      });
  }
}
