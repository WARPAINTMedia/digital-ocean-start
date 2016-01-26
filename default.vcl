#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide at https://www.varnish-cache.org/docs/
# and http://varnish-cache.org/trac/wiki/VCLExamples for more examples.

# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

# Default backend definition. Set this to point to your content server.
backend default {
  .host = "127.0.0.1"; # my local sever
    .port = "8080"; # same as Apache!
    .connect_timeout = 600s;
  .first_byte_timeout = 600s;
  .between_bytes_timeout = 600s;
}

sub vcl_recv {
  # Happens before we check if we have this in cache already.
  #
  # Typically you clean up the request here, removing cookies you don't need,
  # rewriting the request, etc.
  # Happens before we check if we have this in cache already.

  # Properly handle different encoding types
  if (req.http.Accept-Encoding) {
    if (req.url ~ "\.(jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf|woff)$") {
      # No point in compressing these
      unset req.http.Accept-Encoding;
    } elsif (req.http.Accept-Encoding ~ "gzip") {
      set req.http.Accept-Encoding = "gzip";
    } elsif (req.http.Accept-Encoding ~ "deflate") {
      set req.http.Accept-Encoding = "deflate";
    } else {
      # unknown algorithm (aka crappy browser)
      unset req.http.Accept-Encoding;
    }
  }

  # Cache files with these extensions
  if (req.url ~ "\.(js|css|jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf|woff)$") {
    unset req.http.cookie;
    return (hash);
  }

  # Dont cache anything thats on the blog page or thats a POST request
  if (req.url ~ "^/admin" || req.method == "POST") {
    return (pass);
  }

  # This is Laravel specific, we have session-monster which sets a no-session header if we dont really need the set session cookie.
  # Check for this and unset the cookies if not required
  # Except if its a POST request
  if (req.method != "POST") {
    unset req.http.Set-Cookie;
    unset req.http.cookie;
  }

  return (hash);
}

sub vcl_backend_response {
  # Happens after we have read the response headers from the backend.
  #
  # Here you clean the response headers, removing silly Set-Cookie headers
  # and other mistakes your backend does.
  # This is how long Varnish will cache content. Set at top for visibility.
  set beresp.ttl = 300s;

  if ((bereq.method == "GET" && bereq.url ~ "\.(css|js|xml|gif|jpg|jpeg|swf|png|zip|ico|img|wmf|txt)$") ||
      bereq.url ~ "\.(minify).*\.(css|js).*" ||
      bereq.url ~ "\.(css|js|xml|gif|jpg|jpeg|swf|png|zip|ico|img|wmf|txt)\?ver") {
    unset beresp.http.Set-Cookie;
    set beresp.ttl = 5d;
  }

  # Unset all cache control headers bar Age.
  unset beresp.http.etag;
  unset beresp.http.Cache-Control;
  unset beresp.http.Pragma;

  # Unset headers we never want someone to see on the front end
  unset beresp.http.Server;
  unset beresp.http.X-Powered-By;

  # Set how long the client should keep the item by default
  set beresp.http.cache-control = "max-age = 300";

  # Set how long the client should keep the item by default
  set beresp.http.cache-control = "max-age = 300";

  # Override browsers to keep styling and dynamics for longer
  if (bereq.url ~ ".minify.*\.(css|js).*") { set beresp.http.cache-control = "max-age = 604800"; }
  if (bereq.url ~ "\.(css|js).*") { set beresp.http.cache-control = "max-age = 604800"; }

  # Override the browsers to cache longer for images than for main content
  if (bereq.url ~ ".(xml|gif|jpg|jpeg|swf|css|js|png|zip|ico|img|wmf|txt)$") {
    set beresp.http.cache-control = "max-age = 604800";
  }

  # We're done here, send the data to the browser
  return (deliver);
}

sub vcl_deliver {
  # Happens when we have all the pieces we need, and are about to send the
  # response to the client.

  # set the CORS header
  set resp.http.Access-Control-Allow-Origin = "*";
  # You can do accounting or modifying the final object here.
  unset resp.http.Via;
  unset resp.http.X-Varnish;
  # Tell me on the frontend if this item was fetched from cache
  # useful for debugging
  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";
  } else {
    set resp.http.X-Cache = "MISS";
  }
}

