// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require cocoon
//= require private_pub
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function() {
    $(document).bind('ajax:error', function (event, xhr, status, error) {
        if (xhr.status == 403) {
            $('.alert').val("<%= I18n.t('unauthorized.default')%>");
        }
        ;
        if (xhr.status == 401) {
            $('.alert').val("<%= I18n.t('devise.failure.unauthenticated')%>");
        }
        ;
    });
});

