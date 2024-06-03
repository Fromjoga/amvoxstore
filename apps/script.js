function down(id,link) {if(document.documentElement.clientHeight < 900 && document.documentElement.clientHeight > 700){window.open(link, "_blank");return;}const dd = document.getElementById(id);window.scroll({top: dd.getBoundingClientRect().top + window.pageYOffset,behavior: 'smooth'});}
function link(l) {window.open(l, "_blank")}
document.addEventListener("DOMContentLoaded", function() {
            const paginaPrincipal = 'principal.html';
            const caminhoAtual = window.location.pathname.split('/').pop();

            if (caminhoAtual !== '' && caminhoAtual !== paginaPrincipal && caminhoAtual !== '404.html') {
                window.location.href = '404.html';
            }
        });