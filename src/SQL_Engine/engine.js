define('SQL_Engine/engine',
    [
        'jquery',
        'lodash',
        'SQL_Engine/sqlParser'
    ],
    function ($, _, sqlParser) {
        return {
            bd: [],
            query: {},
            fill: function (data) {
                this.bd = data;
                this._renderBD();
            },
            render: function (query) {
                var obj = this._parseQuery(query),
                    nonSelect = this._expandKey(obj)[0],
                    params = [],
                    data = [];
                if (obj.tables.length >= 2) {
                    nonSelect = this._join(this._expandKey(obj), obj.where);
                }
                params = this._parseSelect(query);
                data = this._select(params, nonSelect);
                this._renderResult(data);

            },
            _renderBD: function(){
                $('.fullTable').html(
                    _.template( $('#database').html())( {bd: this.bd})
                )
            },
            _renderResult: function(obj){
                $('.result').html(
                    _.template( $('#result').html())( {result: obj})
                )
            },
            _parseQuery: function (obj) {
                obj.tables = _.map(obj.from, function (n) {
                    return n;
                });
                if (obj.join) {
                    obj.tables.push(obj.join);
                }
                if (obj.where) {
                    this._condition(obj);
                }
                return obj;
            },
            _expandKey: function (obj) {
                var res = [];

                return  _.map(obj.tables, function (el) {
                    var nameTable = el,
                        resItem = {};
                    el = this.bd[el];
                    res = [];

                    for (var i = 0; i < el.length; i ++){
                        resItem = {};
                        _.forEach(el[i], function (n, key) {
                            resItem[nameTable + '.' + key.toLowerCase()] = n;
                        });
                        res.push(resItem);
                    }
                    el = res;
                    return el;

                }, this);


            },
            _join: function (tableBD, where) {
                var res = [],
                    check = where;
                console.log(tableBD, 'tableBD');

                while (tableBD.length >= 2) {
                    var extl = tableBD[0],
                        intl = tableBD[1],
                        maxExtl = extl.length,
                        maxIntl = intl.length,
                        col = {};

                    for (var i = 0; i < maxExtl; i++) {
                        for (var j = 0; j < maxIntl; j++) {
                            col = {};
                            if (!(check) || (check && this._assay(extl[i], intl[j]))) {
                                _.assign(col, extl[i], intl[j]);
                                res.push(col);
                            }
                        }
                    }
                    check = false;
                    tableBD.splice(0, 2, res);

                }
                return res;
            },
            _parseSelect: function (obj){
                var params = [],
                    selection = obj.select;
                if (selection[0].table) {
                    for (var i = 0; i < selection.length; i++) {
                        params.push(selection[i].table + '.' + selection[i].column);
                    }
                } else {
                    for (var z = 0; z < obj.from.length; z++){
                        for(var j = 0; j < selection.length; j++){
                            params.push(obj.from[z] + '.' + selection[j].column)
                        }
                    }
                }
                return params;
            },
            _select: function (params, obj){
                var max = obj.length,
                    res = [],
                    item = {};

                for (var i = 0; i < max; i++) {
                    item = {};
                    for(var j = 0; j < params.length; j++){
                        item[params[j]] = obj[i][params[j]]
                    }
                    res.push(item);
                }
                return res;
            },
            _condition: function (obj) {

                var comparable = obj.where.comparable.table,
                    value = obj.where.value,
                    compositeValue = '',
                    prop = obj.where.comparable.table + '.' + obj.where.comparable.column;

                if (typeof(value) == 'object') {
                    obj.tables = _.without(obj.tables, value.table);
                    (obj.tables).unshift(value.table);
                    compositeValue = obj.where.value.table + '.' + obj.where.value.column;
                }

                obj.tables = _.without(obj.tables, comparable);
                (obj.tables).unshift(comparable);


                switch (obj.where.operator) {
                    case '=' :
                        this._assay = function (a, b) {
                            var first = (typeof(a[prop]) == 'string') ? a[prop].toLowerCase() :
                                    a[prop],
                                second = (function () {
                                    return compositeValue ? b[compositeValue] : value;
                                })();

                            return first == second;
                        };
                        break;
                    case '>' :
                        this._assay = function (a, b) {
                            var first = (typeof(a[prop]) == 'string') ? a[prop].toLowerCase() :
                                    a[prop],
                                second = (function () {
                                    return compositeValue ? b[compositeValue] : value;
                                })();

                            return first > second;
                        };
                        break;
                    default:
                        throw new Error('incorrect operator')
                }

            }
        };
    });

