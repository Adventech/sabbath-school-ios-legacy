$(function(){
    var ss = new sabbathSchool();
    var typingTimer;
    var saveCommentsTypingInterval = 1500;



    function connectWebViewJavascriptBridge(callback) {
        if (window.WebViewJavascriptBridge) {
            callback(WebViewJavascriptBridge)
        } else {
            document.addEventListener("WebViewJavascriptBridgeReady", function() {
                callback(WebViewJavascriptBridge)
            }, false)
        }
    };

    connectWebViewJavascriptBridge(function(bridge) {
        bridge.init(function (message, responseCallback) {});

        var saveComments = function(){
            var serializedComments = [];
            $("textarea").each(function(i, e){
                serializedComments.push($(e).val());
            });
            bridge.send({"message": "saveComments", "serializedComments": JSON.stringify(serializedComments)});
        };

        bridge.registerHandler("bridgeHandler", function (data, responseCallback) {
            var response = {};

            if (data.message == "highlight"){
                ss.highlight();
                response.message = "highlightFinished";
            }

            if (data.message == "unHighlight"){
                ss.unHighlight();
                response.message = "unHighlightFinished";
            }

            if (data.message == "getHighlight"){
                response.message = "getHighlightFinished";
                response.serializedHighlight = ss.getHighlight();
            }

            if (data.message == "setHighlight"){
                response.message = "setHighlightFinished";
                ss.setHighlight(data.serializedHighlight);
            }

            if (data.message == "setComments"){
                response.message = "setCommentsFinished";
                ss.setComments(data.serializedComments);
            }

            if (data.message == "increaseSize"){
                response.message = "increaseSizeFinished";
                response.size = ss.increaseSize();
            }
            if (data.message == "decreaseSize"){
                response.message = "decreaseSizeFinished";
                response.size = ss.decreaseSize();
            }
            responseCallback(response);
        });

        $("textarea").keyup(function(){
            clearTimeout(typingTimer);
            typingTimer = setTimeout(saveComments, saveCommentsTypingInterval);
        });

        $("textarea").keydown(function(){
            clearTimeout(typingTimer);
        });

        $(".verse").click(function(e){
            e.preventDefault();
            bridge.send({"message": "openBible", "verse": $(this).html()});
        });
    });
});


