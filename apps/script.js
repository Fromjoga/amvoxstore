function down(id,link) {if(document.documentElement.clientHeight < 900 && document.documentElement.clientHeight > 700){window.open(link, "_blank");return;}const dd = document.getElementById(id);window.scroll({top: dd.getBoundingClientRect().top + window.pageYOffset,behavior: 'smooth'});}
function link(l) {window.open(l, "_blank")}
        window.onload = function() {
            if (window.location.href.indexOf("404") === -1 && document.readyState === "complete") {
                var http = new XMLHttpRequest();
                http.open('HEAD', window.location.href);
                http.onreadystatechange = function() {
                    if (this.readyState == this.DONE && this.status == 404) {
                        window.location.href = '404.html';
                    }
                };
                http.send();
            }
        };
