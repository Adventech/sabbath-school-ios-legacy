var sabbathSchool = Class({
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
        this.highlighter.highlightSelection("highlight");
    },

    unHighlight: function(){
        this.highlighter.unhighlightSelection();
    },
    getHighlight: function(){
        return this.highlighter.serialize();
    },
    setHighlight: function(serializedHighlight){
        this.highlighter.deserialize(serializedHighlight);
    },
    setComments: function(serializedComments){
        serializedComments = JSON.parse(serializedComments);
        for (var i = 0; i < serializedComments.length; i++){
            $("textarea:eq("+i+")").val(serializedComments[i]);
        }
    }
});