function contentLoaded() {
    window.webkit.messageHandlers.initialLoad.postMessage({});
}

document.addEventListener('DOMContentLoaded', contentLoaded);
