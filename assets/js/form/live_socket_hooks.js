export default class EffectiveFormLiveSocketHooks {
  constructor() {
    return {
      updated() {
        $(this.el).find('select').selectpicker('init');
      },

      mounted() {
        $(this.el).trigger('effective-form:initialize');
      }
    }
  }
}
