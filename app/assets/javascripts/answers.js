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
});