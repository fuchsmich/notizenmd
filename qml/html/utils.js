var doc

addEventListener("DOMContentLoaded", function () {
    // If the document doesn't have a viewport meta tag assume it is going to scale poorly and
    // add one so it doesn't.
//    var viewport = content.document.querySelector("meta[name=viewport]");
//    if (!viewport) {
//        viewport = content.document.createElement("meta");
//        viewport.name = "viewport"
//        viewport.content = "width=device-width, initial-scale=1"
//        content.document.head.appendChild(viewport);
//    }

//    if (content.document.images.length > 0) {
//        sendAsyncMessage("JollaEmail:DocumentHasImages", {})
//    }

    content.document.body.addEventListener('click', function (event) {
        if (event.target.nodeName === 'A') {
            event.preventDefault()
            sendAsyncMessage("NotizenMD:OpenLink", {
                "uri":  event.target.href
            });
        }
    })
})

addMessageListener("NotizenMd:UpdateText", function(message){
    var placeholder = content.document.getElementById('placeholder');
    var codeplaceholder = content.document.getElementById('codeplaceholder');

    if (message.data.textFormat === 1) {
        codeplaceholder.innerHTML = '';
        placeholder.innerHTML = marked(message.data.markDown);
    } else if (message.data.textFormat === 0) {
        placeholder.innerHTML = '';
        codeplaceholder.innerHTML = marked(message.data.markDown).replace(/</g,'&lt;').replace(/>/g,'&gt;');
    }
});
