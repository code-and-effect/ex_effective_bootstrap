import "./jquery.maskedInput"

export default class TelephoneInput {
  initialize($element, options) {
    let mask = options['mask'];
    delete options['mask'];
    $element.mask(mask, options);
  }
}
