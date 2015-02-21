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

    $("textarea").keyup(function(){
        clearTimeout(typingTimer);
        typingTimer = setTimeout(saveComments, saveCommentsTypingInterval);
    });

    $("textarea").keydown(function(){
        clearTimeout(typingTimer);
    });

    $(".verse").click(function(e){
        try{
            SSBridge.openBible($(this).html());
        } catch(err){}
    });
});


