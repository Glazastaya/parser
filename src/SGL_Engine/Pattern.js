define('Pattern', [], function () {
    return function Pattern(exec) {
        this.exec = exec;
        this.then = function (transform) {
            return new Pattern(function (str, pos) {
                var r = exec(str, pos);
                return r && { res: transform(r.res), end: r.end };
            });
        };
    };
});
