export default class EffectiveFormLiveSocketHooks {
  constructor() {
    return {
      updated() {
        $(this.el).trigger('effective-form:initialize');
      },

      mounted() {
        $(this.el).trigger('effective-form:initialize');
      }
    }
  }
}
