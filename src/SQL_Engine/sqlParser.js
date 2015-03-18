define('SQL_Engine/sqlParser', ['SQL_Engine/Pattern', 'SQL_Engine/parsers'], function (Pattern, parsers) {
    var txt = parsers.txt,
        opt = parsers.opt,
        rgx = parsers.rgx,
        exc = parsers.exc,
        any = parsers.any,
        seq = parsers.seq,
        rep = (parsers.rep).bind(parsers),

        wsp = rgx(/\s+/),
        wspopt = opt(wsp),

        name = seq(opt(rgx(/'?"?/)), exc(rgx(/\w+/), rgx(/from|where/i)), opt(rgx(/'?"?/))).then(function(r){
            return r[1].toLowerCase();
        }),

        tableColumn = rep(name, txt('.')),

        listColumn = rep(any(txt('*'), tableColumn), rgx(/\s*?\,\s*/)).then(function (r) {
            var result = [],
                resultItem = {},
                max = r.length;
            for (var i = 0; i < max; i++) {
                if (r[i].length) {
                    resultItem = {};
                    resultItem.table = r[i][1] ? r[i][0] : undefined;
                    resultItem.column = r[i][1] ? r[i][1] : r[i][0];
                    result.push(resultItem)
                }
            }
            return result.length ? result : result[0];
        }),

        listName = any(txt('*'), rep(name, rgx(/\s*?\,\s*/))).then(function(r){
            return r.length ? r : r[0]
        }),

        operator = rgx(/<>|>\=|<\=|>|<|\=|like/i).then(function(r){
            return r.toLowerCase()
        }),

        boolean = rgx(/false|true/i).then(function (r) {return r.length === 4;}),

        condition = seq(tableColumn, wspopt, operator, wspopt, any(boolean, tableColumn)).then(function (r) {
            var res = {
                comparable: {
                    table: r[0][0],
                    column: r[0][1]
                },
                operator: r[2],
                value: typeof(r[4]) == "boolean" ? r[4]: (+r[4] || (r[4].length == 2 ? {
                    table: r[4][0],
                    column: r[4][1]
                } : r[4][0]))
            };
            return res;

        }),



        query = seq(
            wspopt,
            rgx(/select/i),
            wspopt,
            listColumn,
            wspopt,
            opt(rgx(/from/i)),
            wspopt,
            listName,
            wspopt,
            opt(rgx(/join/i)),
            wspopt,
            opt(name),
            wspopt,
            opt(any(rgx(/on/i), rgx(/where/i))),
            wspopt,
            opt(condition)
        ).then(function (r) {
        return {
            select: r[3],
            from: r[7],
            join: r[11],
            where: r[15]
        }
    });


    return {
        query: function(str) {
            return query.exec(str, 0).res
        }
    }


});
