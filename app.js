const markdownEl = document.getElementById('markdown');
const previewEl = document.getElementById('preview');

markdownEl.addEventListener('input', () => {
    const markdownText = markdownEl.value;
    previewEl.innerHTML = marked.parse(markdownText);
    document.querySelectorAll('pre code').forEach((block) => {
        hljs.highlightBlock(block);
    });
});

if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/sw.js');
}
