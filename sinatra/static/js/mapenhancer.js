
enhanceMap = function (doc) {
    var roomHash = {};
    $(doc).find('#rooms').find('g').each(function(i,e){
        var id = $('tspan:contains("###")',e).attr('id');
        var name = n= $('tspan',e).not(':contains("###")').text();

        roomHash[ name ] = id;
    });

    function refreshSVGMap() {
        $.each(roomHash, function (name, id) {
            $.getJSON('/users/by-room/'+ encodeURIComponent(name) , function(data){
                if( data && data.length!==0 ) {
                    $(doc).find('#'+id).text( data.length + ' hacker'+(data.length==1?'':'s'));
                } else {
                    $(doc).find('#'+id).text("NIL");
                }
            } );
        });
    }

    return {
        'refresh' : refreshSVGMap
    }
}
