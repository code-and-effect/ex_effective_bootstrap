const effectiveRegExp = function(string) {
  new RegExp(string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g') // $& means the whole matched string
}

let initInputsFor = function() {
  $(document).find("div.effective-inputs-for:not(.initialized)").each(function(i, element) {
    let $element = $(element)
    let $template = $(element).children('.effective-inputs-for-template').first()

    let $fields = $template.children('.nested-fields').first()

    // [ "team[mates][3]", "team[mates]", "3"]
    let names = $fields.find('input').first().attr('name').match(/^(.*)\[0\]\[/)

    // [ "team_mates_3_", "team_mates", "3" ]
    let ids = $fields.find('input').first().attr('id').match(/^(.*)_0_/)

    let name = names[0].replace('0', "EIFINDEX")
    let id = ids[0].replace('0', "EIFINDEX")

    let name_regex = new RegExp(names[0].replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g')
    let id_regex = new RegExp(ids[0], 'g')

    // Build Template
    let template = $fields[0].outerHTML.replace(name_regex, name).replace(id_regex, id)

    $template.remove()
    $element.data('template', template)
    $element.addClass('initialized')
  });
}

// BootstrapInputsFor Events
$(document).on('click', '[data-effective-inputs-for-add]', function(event) {
  event.preventDefault()

  let $element = $(event.currentTarget).closest('.effective-inputs-for')
  if ($element.length == 0) { return false }

  let uid = (new Date).valueOf()
  let template = $element.data('template').replace(/EIFINDEX/g, uid)

  let $template = $(template).hide()

  if (window.EffectiveForm) { window.EffectiveForm.initialize($template); }

  $(event.currentTarget).before($template.fadeIn('slow'))

  return false
})

$(document).on('click', '[data-effective-inputs-for-delete]', function(event) {
  event.preventDefault()

  let $target = $(event.currentTarget)
  let $input = $target.siblings("input[type='hidden']").first()
  let $fields = $target.closest('.nested-fields').first()

  if ($input.length > 0) {
    $input.val('true')
    $fields.fadeOut('slow')
  } else {
    $fields.fadeOut('slow', function () { this.remove() })
  }

  return false
})

$(document).ready(initInputsFor);

