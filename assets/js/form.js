export default class EffectiveForm {
  constructor() {
    this.currentSubmit = "";
  }

  version() { return "0.1.1"; }

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
    this.flashSuccess();
    return true;
  }

  invalidate($form) {
    this.reset($form);

    $form.addClass('was-validated');
    $form.addClass('form-is-invalid');
    $form.find('.effective-current-submit').removeClass('.effective-current-submit');

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
        if(fun) { fun(); }
      });
  }
}
