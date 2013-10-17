(function () {
  "use strict";
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var doubleClickProtection = function () {
    $('form input[type=submit]').live('click', function () {
      var submit = $(this),
          name = submit.attr('name'),
          value = submit.val();

      if (submit.data('confirm')) {
        return;
      }

      submit.before('<input type="hidden" name="' + name + '" value="' + value + '">');
      submit.attr('disabled', 'disabled');
      submit.closest('form').submit();
    });
  }

  root.GOVUK.doubleClickProtection = doubleClickProtection;
}).call(this);
