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
        if (xhr.status == 422) {
          errors = $.parseJSON(xhr.responseText);
          $.each(errors, function(index,value){
            $('.question-errors').append('<p>'+value+'</p>');
          });
        };
        //if (xhr.status == 403) {
        //  $('.question-errors').append("You don't have rights to perform this action.");
        //};
        //if (xhr.status == 401) {
        //  $('.question-errors').append("You need to sign in or sign up before continuing.");
        //};
    });

    PrivatePub.subscribe("/questions", function(data, channel) {
        $('.questions').append('<p><a href="/questions/' + data.new_question.id + '">' + data.new_question.title + '</a></p>');
    });
});

