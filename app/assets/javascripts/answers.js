function getId($object) {
    $object_with_id = $object.closest('.read_answer_section');
    if ($object_with_id === undefined) {
        $object_with_id = $object.closest('.edit_answer_section');
    };
    object_id = $object_with_id.attr('id');
    return object_id;
};



function answerReadMode() {
    $(".read_answer_section").removeClass("hidden");
    $(".write_answer_section").addClass("hidden");
    $(".new_answer").removeClass('hidden');

};

$(document).ready(function() {
    $('.answers').on('click', 'a.edit_answer_link', function() {
        object_id = getId($(this));
        $(".read_question_section").removeClass("hidden");
        $(".write_question_section").addClass("hidden");
        $(".read_answer_section").removeClass("hidden");
        $(".write_answer_section").addClass("hidden");
        $(".read_answer_section#" + object_id).addClass("hidden");
        $(".write_answer_section#" + object_id).removeClass("hidden");
        $(".new_answer").addClass('hidden');
    });
    $('.answers').on('click', 'a.cancel_edit_answer_link', function() {
        answerReadMode();
    });

    $('form.edit_answer').bind('ajax:before', function () {
        $('.answer-errors').empty();
    }).bind('ajax:success', function(event, data, status, xhr) {
        answer = $.parseJSON(xhr.responseText).answer;
        $('.answer.read_answer_section#answer_' + answer.id).children().first().replaceWith("<p>" + answer.body + "</p>");
        answerReadMode();
    }).bind('ajax:error', function(event,xhr,status,error) {
        if (xhr.status == 422) {
            errors = $.parseJSON(xhr.responseText);
            $.each(errors, function(index,value){
                $('.answer-errors').append("<p>"+value+"</p>");
            });
        };
        //if (xhr.status == 403) {
        //    $('.answer-errors').append("<p>You don't have rights to perform this action.</p>");
        //};
        //if (xhr.status == 401) {
        //    $('.answer-errors').append("<p>You need to sign in or sign up before continuing.</p>");
        //};
    });
});