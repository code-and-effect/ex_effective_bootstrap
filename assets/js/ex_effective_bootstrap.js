/*!
 * --------------------------------------------------------------------------
 * ExEffectiveBootstrap
 * https://github.com/code-and-effect/ex_effective_bootstrap/
 * --------------------------------------------------------------------------
*/

import css from "../css/ex_effective_bootstrap.scss"

import EffectiveBootstrap from "./base"
import EffectiveForm from "./form"

export { EffectiveBootstrap, EffectiveForm }

$(document).ready(function () {
  window.EffectiveBootstrap.initialize();
});

$(document).on('turbolinks:load', function () {
  window.EffectiveBootstrap.initialize();
});

$(document).on('effective-bootstrap:initialize', function (event) {
  window.EffectiveBootstrap.initialize(event.currentTarget);
});
