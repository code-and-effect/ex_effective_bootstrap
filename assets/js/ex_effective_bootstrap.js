/*!
 * --------------------------------------------------------------------------
 * ExEffectiveBootstrap
 * https://github.com/code-and-effect/ex_effective_bootstrap/
 * --------------------------------------------------------------------------
*/

import css from "../css/ex_effective_bootstrap.scss"

import EffectiveForm from "./form/base"
import EffectiveFormLiveSocketHooks from "./form/live_socket_hooks"

import "./tabs/base"
import "./inputs_for/base"
import "./pos_integer/base"
import "./radios/base"

export { EffectiveForm, EffectiveFormLiveSocketHooks }

// Initialize EffectiveForm on the window
window.EffectiveForm || (window.EffectiveForm = new EffectiveForm);

// And set up any form inputs on ready
$(document).ready(window.EffectiveForm.initialize);
$(document).on('turbolinks:load', window.EffectiveForm.initialize);

$(document).on('effective-form:initialize', function(event) {
  window.EffectiveForm.initialize(event.currentTarget);
});
