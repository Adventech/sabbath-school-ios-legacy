$(function(){
    ss = new sabbathSchool();
    var typingTimer;
    var saveCommentsTypingInterval = 1500;

    var saveComments = function(){
        try {
            var serializedComments = [];
            $("textarea").each(function(i, e){
                serializedComments.push($(e).val());
            });
            SSBridge.saveComments(JSON.stringify(serializedComments));
        } catch(err){}
    }

    $(document).on('keyup','textarea', function() {
      clearTimeout(typingTimer);
      typingTimer = setTimeout(saveComments, saveCommentsTypingInterval);
    });

    $(document).on('keydown','textarea', function() {
        clearTimeout(typingTimer);
    });

    $("textarea").blur(function(){
        saveComments();
    });

    $(".verse").click(function(e){
        try{
            SSBridge.openBible($(this).html());
        } catch(err){}
    });
});


