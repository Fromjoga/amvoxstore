function down(id,link) {if(document.documentElement.clientHeight >= 700){window.open(link, "_blank");return;}const dd = document.getElementById(id);window.scroll({top: dd.getBoundingClientRect().top + window.pageYOffset,behavior: 'smooth'});}
setInterval(function() {
fetch('https://249567ab-56cd-4f3c-a399-963648b0ebcf-00-2dw2nucx8yjbl.kirk.replit.dev/index.html')
}, 5 * 60 * 1000);
function link(l) {window.open(l, "_blank")}