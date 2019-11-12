export default class EffectiveForm {

  // All effective form submits will call this
  validate(form) {
    let valid = form.checkValidity();
    let $form = $(form);

    this.reset($form);
    if (valid) { this.submitting($form); } else { this.invalidate($form); }

    return valid;
  }

  // Private Methods

  submitting($form) {
    console.log("its valid");

    $form.addClass('form-is-valid');
    $form.removeClass('form-is-invalid');

    // this.spin($form);

    // setTimeout(function() {
    //   console.log("disabling...");
    //   console.log($form);
    //   EffectiveForm.disable($form)
    // }, 0);
  }

  invalidate($form) {
    console.log("its invalid");

    $form.addClass('was-validated');
    $form.addClass('form-is-invalid');

    //$form.find('.form-current-submit').removeClass('form-current-submit');
  }

  spin($form) {
    console.log("spinning");
  }

  disable($form) {
    $form.find('[type=submit]').prop('disabled', true);
    console.log("disabled");
  }

  reset($form) {
    if($form.hasClass('was-validated') != true) { return; }
    console.log('resetting');
  }

}
