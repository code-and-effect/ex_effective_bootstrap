/*!
 * --------------------------------------------------------------------------
 * ExEffectiveBootstrap
 * https://github.com/code-and-effect/ex_effective_bootstrap/
 * --------------------------------------------------------------------------
*/

import css from "../css/ex_effective_bootstrap.scss"

import EffectiveForm from "./form"
import EffectiveFormLiveSocketHooks from "./live_socket"

export { EffectiveForm, EffectiveFormLiveSocketHooks }

window.EffectiveForm || (window.EffectiveForm = new EffectiveForm());

$(document).ready(function () {
  window.EffectiveForm.initialize();
});

$(document).on('turbolinks:load', function () {
  window.EffectiveForm.initialize();
});

$(document).on('effective-form:initialize', function (event) {
  window.EffectiveForm.initialize(event.currentTarget);
});
