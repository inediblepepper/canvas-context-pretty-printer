<%--
Copyright (c) 2011, salesforce.com, inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided
that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the
following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of salesforce.com, inc. nor the names of its contributors may be used to endorse or
promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
--%>

<%@ page import="canvas.SignedRequest" %>
<%@ page import="java.util.Map" %>
<%
    // Pull the signed request out of the request body and verify/decode it.
    Map<String, String[]> parameters = request.getParameterMap();
    String[] signedRequest = parameters.get("signed_request");
    if (signedRequest == null) {%>
        This App must be invoked via a signed request!<%
        return;
    }
    String yourConsumerSecret=System.getenv("CANVAS_CONSUMER_SECRET");
    String signedRequestJson = SignedRequest.verifyAndDecodeAsJson(signedRequest[0], yourConsumerSecret);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Force.com Canvas Java Quick Start</title>

        <link rel="stylesheet" type="text/css" href="/sdk/css/canvas.css" />

        <script type="text/javascript" src="/sdk/js/canvas-all.js"></script>
        <script type="text/javascript" src="/scripts/json2.js"></script>

        <script>
            if (self === top) {
                // Not in Iframe
                alert("This canvas app must be included within an iframe");
            }

            Sfdc.canvas(function() {
                var sr = JSON.parse('<%=signedRequestJson%>');
                Sfdc.canvas.client.autogrow(sr.client);
                Sfdc.canvas.byId('canvas-request-string').innerHTML = jsonSyntaxHighlight(sr);
            });
            
            function jsonSyntaxHighlight(json) {
                if (typeof json != 'string') {
                     json = JSON.stringify(json, undefined, 2);
                }
                json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
                    var cls = 'number';
                    if (/^"/.test(match)) {
                        if (/:$/.test(match)) {
                            cls = 'key';
                        } else {
                            cls = 'string';
                        }
                    } else if (/true|false/.test(match)) {
                        cls = 'boolean';
                    } else if (/null/.test(match)) {
                        cls = 'null';
                    }
                    return '<span class="' + cls + '">' + match + '</span>';
                });
            }

        </script>
        <style>
pre {white-space: pre-wrap;padding: 5px; margin: 5px; }
.string { color: green; }
.number { color: darkorange; }
.boolean { color: blue; }
.null { color: magenta; }
.key { color: red; }
        </style>
    </head>
    <body>
    <div id="page">
        <div id="content">
            <div id="header">
                <h2>Welcome to the Force.com Canvas Request Context Pretty-Print Utility!</h2>
            </div>

            <div id="canvas-content">
                <h2>Below is the JSON representation of Canvas Request:</h2>
                <pre id="canvas-request-string">
                <!-- TODO -->
                </pre>
            </div>
        </div>

        <div id="footercont">
            <div id="footerleft">
                <p>Powered By: <a title="Heroku" href="#" onclick="window.top.location.href='http://www.heroku.com'"><strong>Heroku</strong></a></p>
            </div>
            <div id="footerright">
                <p>Salesforce: <a title="Safe Harbor" href="http://www.salesforce.com/company/investor/safe_harbor.jsp"><strong>SafeHarbor</strong></a></p>
            </div>
        </div>
    </div>
    </body>
 </html>
