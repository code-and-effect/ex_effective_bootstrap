export default class EffectiveForm {
  constructor() {
    this.currentSubmit = '';
  }

  onSubmitClick(input) {
    this.currentSubmit = $(input);
    return true;
  }

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
    $form.find('.effective-current-submit').removeClass('.effective-current-submit');

    this.flashInvalid();

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
    $form.find('.effective-current-submit').removeClass('.effective-current-submit');
    $form.find('[type=submit]').removeAttr('disabled');

    return true;
  }

  // flashIcon(name) {
  //   this.currentSubmit.find('.eb-icon-' + name).show();
  // }

  flashInvalid() {
    if(this.currentSubmit.length == 0) { return false; }
    this.currentSubmit.find('.eb-icon-times').show().delay(1000).fadeOut('slow')
  }

}


// flash: ($form, status, message, skip_success = false) ->
//     return unless @current_submit.length > 0

// if status == 'danger' || status == 'error'
//       @current_submit.find('.eb-icon-x').show().delay(1000).fadeOut('slow', -> $form.trigger('effective-form:error-animation-done', @remote_form_commit, message))
//     else
// @current_submit.find('.eb-icon-check').show().delay(1000).fadeOut('slow', -> $form.trigger('effective-form:success-animation-done', @remote_form_commit, message))

// if message ? && !(status == 'success' && skip_success)
//       @current_submit.prepend(@buildFlash(status, message))




// console.log('here')

// Sets EffectiveBootstrap.current_click.
// This displays the spinner here, and directs any flash messages before and after loadRemoteForm
// $(document).on('click', '.effective-form-actions button[type=submit],.effective-form-actions a[data-remote]', function(event) {
//   EffectiveForm.setCurrentSubmit($(event.currentTarget));
//   EffectiveForm.spin();
// });

// // Clear
// $(document).on('reset', 'form', function(event) {
//   $form = $(event.currentTarget);
//   EffectiveForm.reset($form);
// });

// $(document).on('clear', 'form', function(event) {
//   $form = $(event.currentTarget);
//   EffectiveForm.reset($form);
//   setTimeout(function () { EffectiveForm.clear($form); });
// });

