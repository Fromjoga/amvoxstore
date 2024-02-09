function down(id,link) {if(document.documentElement.clientHeight < 1024 || document.documentElement.clientHeight >= 650){window.open(link, "_blank");return;}const dd = document.getElementById(id);window.scroll({top: dd.getBoundingClientRect().top + window.pageYOffset,behavior: 'smooth'});}
function link(l) {window.open(l, "_blank")}
