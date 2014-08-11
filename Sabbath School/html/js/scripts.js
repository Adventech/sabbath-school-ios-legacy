$(function(){
    var ss = new sabbathSchool();

    function connectWebViewJavascriptBridge(callback) {
        if (window.WebViewJavascriptBridge) {
            callback(WebViewJavascriptBridge)
        } else {
            document.addEventListener('WebViewJavascriptBridgeReady', function() {
                callback(WebViewJavascriptBridge)
            }, false)
        }
    }

    connectWebViewJavascriptBridge(function(bridge) {
        bridge.init(function (message, responseCallback) {
            //alert(message);
            //var data = { 'Javascript Responds': 'Wee!' };
            //responseCallback(data)
        });

        bridge.registerHandler('bridgeHandler', function (data, responseCallback) {
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
            responseCallback(response);
        });

        $("textarea").blur(function(){
            var serializedComments = [];
            $("textarea").each(function(i, e){
                serializedComments.push($(e).val());
            });
            bridge.send({"message": "saveComments", "serializedComments": JSON.stringify(serializedComments)});
        });

        $(".verse").click(function(e){
            e.preventDefault();
            bridge.send({"message": "openBible", "verse": $(this).html()});
        });
    });
});


