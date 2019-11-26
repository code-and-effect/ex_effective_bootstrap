import $ from "jquery"
import TelephoneInput from "./telephone_input/base"

const effective_inputs = {
  'telephone_input': TelephoneInput
}

export default class EffectiveBootstrap {
  initialize(target) {
    $(target || document).find('[data-input-js-options]:not(.initialized)').each(function(i, element) {
      let $element = $(element);
      let options = $element.data('input-js-options');

      let method_name = options['method_name'];
      delete options['method_name'];

      if (!effective_inputs[method_name]) {
        return console.error("ExEffectiveBootstrap " + method_name + " has not been implemented");
      }

      let effective_input = new effective_inputs[method_name];
      effective_input.initialize($element, options);
      $element.addClass('initialized');
    });

    return true;
  }
}
