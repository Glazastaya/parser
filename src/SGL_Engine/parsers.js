define('parsers', ['Pattern'], function (Pattern) {
    return {
        txt: function (text) {
            return new Pattern(function (str, pos) {
                if (str.substr(pos, text.length) == text)
                    return {res: text, end: pos + text.length};
            });
        },
        rgx: function (regexp) {
            return new Pattern(function (str, pos) {
                var m = regexp.exec(str.slice(pos));
                if (m && m.index === 0)
                    return {res: m[0], end: pos + m[0].length};
            })
        },
        opt: function (pattern) {
            return new Pattern(function (str, pos) {
                return pattern.exec(str, pos) || {res: undefined, end: pos};
            })
        },
        exc: function (pattern, except) {
            return new Pattern(function (str, pos) {
                return !except.exec(str, pos) && pattern.exec(str, pos);
            });
        },
        any: function () {
            var patterns = arguments;
            return new Pattern(function (str, pos) {
                for (var r, i = 0; i < patterns.length; i++)
                    if (r = patterns[i].exec(str, pos))
                        return r;
            });
        },
        seq: function() {
            var patterns = arguments;
            return new Pattern(function (str, pos) {
                var i, r, end = pos, res = [];

                for (i = 0; i < patterns.length; i++) {
                    r = patterns[i].exec(str, end);
                    if (!r) return;
                    res.push(r.res);
                    end = r.end;
                }

                return {res: res, end: end};
            })
        },
        rep: function(pattern, separator) {
            var separated = !separator ? pattern :
            this.seq(separator, pattern).then(function(z) {
                return z[1]
            });

            return new Pattern(function (str, pos) {
                var res = [], end = pos, r = pattern.exec(str, end);

                while (r && r.end > end) {
                    res.push(r.res);
                    end = r.end;
                    r = separated.exec(str, end);
                }

                return { res: res, end: end };
            });
        }
    }
});
