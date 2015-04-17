var sabbathSchool = Class({
    currentSize: 0,
    sizes: ["small", "medium", "large", "x-large"],
    highlighter: null,
    bridge: null,

    constructor: function(){
        rangy.init();
        var serializedHighlights = decodeURIComponent(window.location.search.slice(window.location.search.indexOf("=") + 1));
        this.highlighter = rangy.createHighlighter();
        this.highlighter.addClassApplier(rangy.createCssClassApplier("highlight", {
            ignoreWhiteSpace: true,
            tagNames: ["span", "a"]
        }));

        if (serializedHighlights) {
            this.highlighter.deserialize(serializedHighlights);
        }
    },
    highlight: function(){
        try {
            this.highlighter.highlightSelection("highlight");
            SSBridge.saveHighlights(this.getHighlight());
        } catch(err){}
    },

    unHighlight: function(){
        try {
            this.highlighter.unhighlightSelection();
            SSBridge.saveHighlights(this.getHighlight());
        } catch(err){}
    },

    getHighlight: function(){
        try {
            return this.highlighter.serialize();
        } catch(err){}
    },

    setHighlight: function(serializedHighlight){
        try {
            this.highlighter.deserialize(serializedHighlight);
        } catch(err){};
    },

    setComments: function(serializedComments){
        serializedComments = serializedComments.replace(/\n/g, '\\n');
        try {
            serializedComments = JSON.parse(serializedComments);
            for (var i = 0; i < serializedComments.length; i++){
                $("textarea:eq("+i+")").val(serializedComments[i]);
            }
        } catch(err){
            console.log(err);
        }
    },

    copy: function(){
        SSBridge.copy(window.getSelection().toString());
    },

    share: function(){
        SSBridge.share(window.getSelection().toString());
    },

    search: function(){
        SSBridge.search(window.getSelection().toString());
    }
});