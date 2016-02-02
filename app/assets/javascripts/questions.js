function questionEditMode() {
    $(".read_question_section").addClass("hidden");
    $(".write_question_section").removeClass("hidden");
    $(".read_answer_section").removeClass("hidden");
    $(".write_answer_section").addClass("hidden");
    $(".new_answer").addClass('hidden');
};

function questionReadMode() {
    $(".read_question_section").removeClass("hidden");
    $(".write_question_section").addClass("hidden");
    $(".new_answer").removeClass('hidden');
};

$(document).ready(function() {
    $('a#edit_question_link').click(function() {
      questionEditMode();
    });
    $('a#cancel_edit_question_link').click(function() {
      questionReadMode();
    });

    $('form.edit_question').bind('ajax:before', function () {
        $('.question-errors').empty();
    }).bind('ajax:success', function(event, data, status, xhr) {
        question = $.parseJSON(xhr.responseText);
        $('.read_question_section#content').html('<h1>' + question.title+ "</h1><p>" + question.body + "</p>");
        questionReadMode();
    }).bind('ajax:error', function(event,xhr,status,error) {
        if (error == 'Unprocessable Entity') {
          errors = $.parseJSON(xhr.responseText);
          $.each(errors, function(index,value){
            $('.question-errors').append('<p>'+value+'</p>');
          });
        };
        if (error == 'Forbidden') {
          $('.question-errors').append("You don't have rights to perform this action.");
        };
        if (error == 'Unauthorized') {
          $('.question-errors').append("You need to sign in or sign up before continuing.");
        };
    });
});

