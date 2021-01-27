//
//  Recaptcha.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 07.07.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation

class Recaptcha {
    let htmlString: String
    
    init(captchaId: String) {
        htmlString = """
            <html>
              <head>
                <meta name='viewport' content= 'width=device-width, initial-scale=1.0'>
                <title>reCAPTCHA demo: Simple page</title>
                 <script src="https://www.google.com/recaptcha/api.js" async defer></script>
              </head>
              <body>
                  <button id="b" class="g-recaptcha" data-sitekey=\(captchaId) data-callback="onSubmit">Submit</button>
                  <br/>
                <script>
                   var recaptchaButton = document.getElementById("b");
                   
                   function initListener() {

                     // set a global to tell that we are listening
                     window.recaptchaCloseListener = true;

                     // find the open reCaptcha window
                     HTMLCollection.prototype.find = Array.prototype.find;
                     var recaptchaWindow = document.getElementsByTagName('iframe').find(x=>x.src.includes('google.com/recaptcha/api2/bframe')).parentNode.parentNode;
                 
                     var observer = new MutationObserver((x) => {
                       if (recaptchaWindow.style.opacity === "1") {
                         webkit.messageHandlers.needToResolveCaptcha.postMessage(recaptchaWindow.style.opacity);
                       }
                     });

                     observer.observe(recaptchaWindow, { attributes: true, attributeFilter: ['style'] });
                   }
        
        
                   recaptchaButton.addEventListener('click', function(){
                     if(!window.recaptchaCloseListener) {
                       initListener();
                     }
                   });

                   
                   function onSubmit(token) {
                     webkit.messageHandlers.getToken.postMessage(token);
                   }
                </script>
              </body>
            </html>
        """
    }
}

