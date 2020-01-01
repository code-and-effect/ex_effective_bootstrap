export default class ShowIf {
  initialize($element, options) {
    let $affects = $element.closest('form').find("input[name='" + options.name + "'],select[name='" + options.name + "']");

    $affects.on('change', function(event) {
      if($(event.target).val() == options.value) {
        $element.fadeIn();
        $element.find('input,textarea,select').removeAttr('disabled');
      } else {
        $element.hide();
        $element.find('input,textarea,select').prop('disabled', true);
      }
    });
  }
}
