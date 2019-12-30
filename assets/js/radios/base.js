$(document).on('change', '.effective-radios input', function (event) {
  let $input = $(event.currentTarget);
  let $group = $input.closest('.effective-radios');

  if(($group.hasClass('is-valid') || $group.hasClass('is-invalid')) == false) {
    return false;
  }

  if($input.is(':valid')) {
    $group.addClass('is-valid').removeClass('is-invalid');
  } else {
    $group.addClass('is-invalid').removeClass('is-valid');
  }
});
