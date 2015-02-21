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
    },

    setSize: function(size){
        var newSize = null;
        $("link[data='sizes']").remove();
        for (var i = 0; i < this.sizes.length; i++){
            if (this.sizes[i].toUpperCase() == size.toUpperCase()){
                newSize = i;
            }
        }
        if (newSize != null){
            this.currentSize = newSize;
            $("head").append($('<link rel="stylesheet" data="sizes" type="text/css" />').attr('href', "css/"+size+".css"));
            SSBridge.saveSizePreference(size);
        }
    },

    setSizePreference: function(size){
        for (var i = 0; i < this.sizes.length; i++){
            if (this.sizes[i].toUpperCase() == size.toUpperCase()){
                this.currentSize = i;
            }
        }
    },

    increaseSize: function(){
        if ((this.currentSize + 1) < this.sizes.length){
            this.setSize(this.sizes[(this.currentSize + 1)]);
        }
    },

    decreaseSize: function(){
        if ((this.currentSize - 1) >= 0){
            this.setSize(this.sizes[(this.currentSize - 1)]);
        }
    }
});