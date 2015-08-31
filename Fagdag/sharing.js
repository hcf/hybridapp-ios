jQuery(".fb a").click(function (event) {
                 
    event.stopPropagation();
                      
    var url = window.location.href + "?utm=share_link";
    var title = jQuery("h1.title").text();
    
    window.webkit.messageHandlers.shareUsingFacebook.postMessage(
        {
            url: url,
            title: title,
        }
    );
});