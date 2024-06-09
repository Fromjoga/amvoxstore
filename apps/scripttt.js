function down(id,link) {if(document.documentElement.clientHeight < 900 && document.documentElement.clientHeight > 700){window.open(link, "_blank");return;}const dd = document.getElementById(id);window.scroll({top: dd.getBoundingClientRect().top + window.pageYOffset,behavior: 'smooth'});}
function link(l) {window.open(l, "_blank")}
document.addEventListener("DOMContentLoaded", function() {
            const paginaPrincipal = 'index.html';

            const caminhoAtual = window.location.pathname.split('/').pop();

            if (caminhoAtual !== '' && caminhoAtual !== paginaPrincipal && caminhoAtual !== '404.html') {
                window.location.href = '404.html';
            }
        });
document.onkeydown = function(e) {
    if (e.keyCode === 123 || // F12
        (e.ctrlKey && e.shiftKey && e.keyCode === 73) || // Ctrl+Shift+I
        (e.ctrlKey && e.shiftKey && e.keyCode === 74) || // Ctrl+Shift+J
        (e.ctrlKey && e.keyCode === 85)) { // Ctrl+U
      return false;
    }
  };
if (window.devtools.isOpen === true) {
      window.location = "https://endereco-do-seu-site.com.br/conteudo-protegido.php";
    }
  	window.addEventListener('devtoolschange', event => {
      if (event.detail.isOpen === true) {
        window.location = "https://endereco-do-seu-site.com.br/conteudo-protegido.php";
      }
  	});