function down(id,link) {if(document.documentElement.clientHeight < 900 && document.documentElement.clientHeight > 700){window.open(link, "_blank");return;}const dd = document.getElementById(id);window.scroll({top: dd.getBoundingClientRect().top + window.pageYOffset,behavior: 'smooth'});}
function link(l) {window.open(l, "_blank")}
document.addEventListener("DOMContentLoaded", function() {
            const paginaPrincipal = 'index.html';
            const urlProibidas = ['script.js', 'style.css'];

            const caminhoAtual = window.location.pathname.split('/').pop();

            if ((urlProibidas.includes(caminhoAtual)) || (caminhoAtual !== '' && caminhoAtual !== paginaPrincipal && caminhoAtual !== '404.html')) {
                window.location.href = '404.html';
            }
        });