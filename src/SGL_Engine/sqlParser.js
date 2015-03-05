define('sqlParser', ['Pattern', 'parsers'], function (Pattern, parsers) {
    var txt = parsers.txt,
        opt = parsers.opt,
        rgx = parsers.rgx,
        exc = parsers.exc,
        any = parsers.any,
        seq = parsers.seq,
        rep = (parsers.rep).bind(parsers),


        wsp = rgx(/\s+/),
        wspopt = opt(wsp),
        name = rgx(/\w+/).then(function(r){
            return r.toLowerCase()
        }),
        tableColumn = rep(name, txt('.')),
        operator = rgx(/<>|>\=|<\=|>|<|\=|like/i).then(function(r){
            return r.toLowerCase()
        }),
        value = any(rgx(/\d+/), name),
        boolean = rgx(/false|true/i).then(function (r) {return r.length === 4;}),
        query = seq(
            wspopt,
            rgx(/select/i),
            wspopt,
            any(txt('*'), tableColumn),
            wspopt,
            opt(rgx(/from/i)),
            wspopt,
            opt(any(txt('*'), name)),
            wspopt,
            opt(rgx(/join/i)),
            wspopt,
            opt(any(txt('*'), tableColumn, name)),
            wspopt,
            opt(rgx(/where/i)),
            wspopt,
            opt(name),
            wspopt,
            opt(operator),
            wspopt,
            opt(any(boolean, value))
        ).then(function (r) {
        return {
            select: {
                table: r[3][0],
                column: r[3][1]
            },
            from: {
                table: r[7]
            },
            join: {
                table: r[11][0],
                column: r[11][1]
            },
            where: {
                column: r[15],
                operator: r[17],
                value: typeof(r[19]) == "boolean"? r[19] : (+r[19] || r[19])
            }

        }
    });

    return function (str) {
        return query.exec(str, 0).res
    };


});
