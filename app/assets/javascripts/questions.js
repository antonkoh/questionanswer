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
});