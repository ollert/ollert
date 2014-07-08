var TrelloClient = (function () {
  var opts = {
    "version": 1,
    "apiEndpoint": "https://api.trello.com",
    "authEndpoint": "https://trello.com"
  };
  var deferred, isFunction, isReady, ready, waitUntil, wrapper, __slice = [].slice;
  wrapper = function (c, g, b) {
    var f, d, l, w, y, m, r, n, z, x, e, s, t, u, h, v, p;
    m = b.key;
    e = b.token;
    d = b.apiEndpoint;
    l = b.authEndpoint;
    s = b.version;
    y = "" + d + "/" + s + "/";
    n = c.location;
    f = {
      version: function () {
        return s
      },
      key: function () {
        return m
      },
      setKey: function (a) {
        m = a
      },
      token: function () {
        return e
      },
      setToken: function (a) {
        e = a
      },
      rest: function () {
        var a, c, d, k;
        c = arguments[0];
        a = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        k = z(a);
        d = k[0];
        a = k[1];
        b = {
          url: "" + y + d,
          type: c,
          data: {},
          dataType: "json",
          success: k[2],
          error: k[3]
        };
        g.support.cors || (b.dataType =
          "jsonp", "GET" !== c && (b.type = "GET", g.extend(b.data, {
            _method: c
          })));
        m && (b.data.key = m);
        e && (b.data.token = e);
        null != a && g.extend(b.data, a);
        return g.ajax(b)
      },
      authorized: function () {
        return null != e
      },
      deauthorize: function () {
        e = null;
        t("token", e)
      },
      authorize: function (a) {
        var q, d, k, f, h;
        b = g.extend(!0, {
          type: "redirect",
          persist: !0,
          interactive: !0,
          scope: {
            read: !0,
            write: !1,
            account: !1
          },
          expiration: "30days"
        }, a);
        a = /[&#]?token=([0-9a-f]{64})/;
        d = function () {
          if (b.persist && null != e) return t("token", e)
        };
        b.persist && null == e && (e = x("token"));
        null == e && (e = null != (h = a.exec(n.hash)) ? h[1] : void 0);
        if (this.authorized()) return d(), n.hash = n.hash.replace(a, ""), "function" ===
          typeof b.success ? b.success() : void 0;
        if (!b.interactive) return "function" === typeof b.error ? b.error() : void 0;
        k = function () {
          var a, c;
          a = b.scope;
          c = [];
          for (q in a)(f = a[q]) && c.push(q);
          return c
        }().join(",");
        switch (b.type) {
        case "popup":
          (function () {
            var a, q, e, f;
            waitUntil("authorized", function (a) {
              return function (a) {
                return a ? (d(), "function" === typeof b.success ? b.success() :
                  void 0) : "function" === typeof b.error ?
                  b.error() : void 0
              }
            }(this));
            a = c.screenX + (c.innerWidth - 420) / 2;
            e = c.screenY + (c.innerHeight - 470) / 2;
            q = null != (f = /^[a-z]+:\/\/[^\/]*/.exec(n)) ? f[0] : void 0;
            return c.open(w({
              return_url: q,
              callback_method: "postMessage",
              scope: k,
              expiration: b.expiration,
              name: b.name
            }), "trello", "width=420,height=470,left=" + a + ",top=" + e)
          })();
          break;
        default:
          c.location = w({
            redirect_uri: n.href,
            callback_method: "fragment",
            scope: k,
            expiration: b.expiration,
            name: b.name
          })
        }
      }
    };
    p = ["GET", "PUT", "POST", "DELETE"];
    u = function (a) {
      return f[a.toLowerCase()] =
        function () {
          return this.rest.apply(this, [a].concat(__slice.call(arguments)))
      }
    };
    h = 0;
    for (v = p.length; h < v; h++) d = p[h], u(d);
    f.del = f["delete"];
    p = "actions cards checklists boards lists members organizations lists".split(" ");
    u = function (a) {
      return f[a] = {
        get: function (b, c, d, e) {
          return f.get("" + a + "/" + b, c, d, e)
        }
      }
    };
    h = 0;
    for (v = p.length; h < v; h++) d = p[h], u(d);
    c.Trello = f;
    w = function (a) {
      return l + "/" + s + "/authorize?" + g.param(g.extend({
        response_type: "token",
        key: m
      }, a))
    };
    z = function (a) {
      var b, c, d;
      c = a[0];
      b = a[1];
      d = a[2];
      a = a[3];
      isFunction(b) &&
        (a = d, d = b, b = {});
      c = c.replace(/^\/*/, "");
      return [c, b, d, a]
    };
    d = function (a) {
      var b;
      a.origin === l && (null != (b = a.source) && b.close(), e = null != a.data && 4 <
        a.data.length ? a.data : null, isReady("authorized", f.authorized()))
    };
    r = c.localStorage;
    null != r ? (x = function (a) {
      return r["trello_" + a]
    }, t = function (a, b) {
      return null === b ? delete r["trello_" + a] : r["trello_" + a] = b
    }) : x = t = function () {};
    "function" === typeof c.addEventListener && c.addEventListener("message", d, !1)
  };
  deferred = {};
  ready = {};
  waitUntil = function (c, g) {
    return null != ready[c] ? g(ready[c]) : (null != deferred[c] ? deferred[c] :
      deferred[c] = []).push(g)
  };
  isReady = function (c, g) {
    var b, f, d, l;
    ready[c] = g;
    if (deferred[c]) {
      f = deferred[c];
      delete deferred[c];
      d = 0;
      for (l = f.length; d < l; d++) b = f[d], b(g)
    }
  };
  isFunction = function (c) {
    return "function" === typeof c
  };
  initialize = function (key) {
    opts["key"] = key
    wrapper(window, jQuery, opts);
  }

  return {
    init: initalize
  }
})()