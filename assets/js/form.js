export default class EffectiveForm {

  // All effective form submits will call this
  validate(form) {
    let valid = form.checkValidity();
    let $form = $(form);

    this.reset($form);
    if (valid) { this.submitting($form); } else { this.invalidate($form); }

    return valid;
  }

  submitting($form) {
    $form.addClass('form-is-valid');
    $form.removeClass('form-is-invalid');

    this.spin($form);
    this.disable($form);

    return true;
  }

  invalidate($form) {
    $form.addClass('was-validated');
    $form.addClass('form-is-invalid');
    //$form.find('.form-current-submit').removeClass('form-current-submit');

    return true;
  }

  spin($form) {
    console.log("spin...")
    return true;
  }

  disable($form) {
    $form.find('[type=submit]').prop('disabled', true);
    return true;
  }

  reset($form) {
    if($form.is('form') == false) { $form = $form.closest('form') };

    // Reset the form
    $form.removeClass('was-validated');
    $form.removeClass('form-is-invalid');
    $form.removeClass('form-is-valid');

    // Reset any individual input server side validations
    $form.find('.alert.is-invalid').remove();
    $form.find('.is-invalid').removeClass('is-invalid');
    $form.find('.is-valid').removeClass('is-valid');

    // Reset the submit button
    //$form.find('.form-current-submit').removeClass('form-current-submit');
    $form.find('[type=submit]').removeAttr('disabled');

    return true;
  }

}
