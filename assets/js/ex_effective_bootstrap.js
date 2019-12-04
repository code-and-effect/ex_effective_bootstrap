/*!
 * --------------------------------------------------------------------------
 * ExEffectiveBootstrap
 * https://github.com/code-and-effect/ex_effective_bootstrap/
 * --------------------------------------------------------------------------
*/

import css from "../css/ex_effective_bootstrap.scss"

import EffectiveBootstrap from "./base"
import EffectiveForm from "./form"

window.EffectiveBootstrap || (window.EffectiveBootstrap = new EffectiveBootstrap());
window.EffectiveForm || (window.EffectiveForm = new EffectiveForm());

$(document).ready(function () {
  window.EffectiveBootstrap.initialize();
});

$(document).on('turbolinks:load', function () {
  window.EffectiveBootstrap.initialize();
});

$(document).on('effective-bootstrap:initialize', function (event) {
  window.EffectiveBootstrap.initialize(event.currentTarget);
});
