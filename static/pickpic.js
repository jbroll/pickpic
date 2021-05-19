
// https://github.com/newming/view-bigimg
//

var viewer;
var shown;

function XHR(method, url, payload) {
    var xhr = new XMLHttpRequest();
    xhr.open(method, "/image/" + filename, false);
    xhr.send();
    return xhr.status === 200;
}

function image_op(op, image) {
    filename = new URL(image).pathname.split('/').slice(2).join('/');

    return XHR(op, "/image/" + filename, false);
}

function init() {
    viewer = new ViewBigimg();

    viewer.container.setAttribute("tabindex", "0");
    viewer.container.addEventListener('keydown', function(event) {
        event.preventDefault();
        if ( shown ) {
            switch ( event.key ) {
                case 'Escape': viewer.hide(); return;

                case 'ArrowRight': if ( shown.nextElementSibling     ) { next = shown.nextElementSibling     };  break;
                case 'ArrowLeft':  if ( shown.previousElementSibling ) { next = shown.previousElementSibling };  break;
                case 's':  {
                        image_op("PUT", shown.src);     break;
                }
                case 'd':  {
                    if ( shown.nextElementSibling ) { 
                        next = shown.nextElementSibling
                    } else {
                        next = shown.previousElementSibling
                    }

                    if ( shown != next ) {
                        if ( image_op("DELETE", shown.src) ) {
                            shown.remove();
                        } else {
                            next = shown;
                        }
                    }
                    break;
                }
            }
            shown = next;
            viewer.show(shown.src);
        }
    });

    var grid = document.getElementById('imggrid');
    grid.onclick = function (e) {
        if (e.target.nodeName === 'IMG') {
           viewer.show(e.target.src);
           viewer.container.focus();
           shown = e.target;
        }
    }
}

init();
