
define('app', ['jquery', 'SQL_Engine/engine', 'SQL_Engine/sqlParser'],
    function($, engine, sqlParser){
        return {
            init: function(){
                var query = '';
                $.ajax({
                    url: "api/db.json"
                }).done(function (data) {
                    engine.fill(data);
                });


                $('.select').on('click', function(){
                    var obj = {};
                    query = $.trim($('.query').val());
                    if (query) {
                        obj = sqlParser.query(query);
                        engine.render(obj);
                    }

                });
            }
        }






    });
