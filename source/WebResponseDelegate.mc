using Toybox.Communications;

class WebResponseDelegate
{
    hidden var _callback;
    hidden var _params;

    function initialize(params) {
        self._params = params;
    }

    function onWebResponse(code, data) {
        _callback.invoke(code, data, self._params);
    }

    function makeDefaultWebRequest(url, params, options, callback) {
        _callback = callback;
        Communications.makeWebRequest(url, params, options, self.method(:onWebResponse));
    }
    
    //https://forums.garmin.com/forum/developers/connect-iq/143937-
    function makeWebRequest(url, callback) {
        _callback = callback;
        var options = {
         :method => Communications.HTTP_REQUEST_METHOD_GET,
         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       	};
        Communications.makeWebRequest(url, null, options, self.method(:onWebResponse));
    }
}