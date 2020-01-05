// Prevent non - currency buttons from being pressed
$(document).on('keydown', "input[type=text][data-pos-integer]", function(event) {
  allowed =  ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

  if(event.key && event.key.length == 1 && event.metaKey == false && allowed.indexOf(event.key) == -1) {
    event.preventDefault();
  };

});
