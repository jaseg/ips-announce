
enhanceMap = function (doc) {
    var roomHash = {};
    $(doc).find('#rooms').find('g').each(function(i,e){
        var id = $('tspan:contains("###")',e).attr('id');
        var name = n= $('tspan',e).not(':contains("###")').text();

        roomHash[ name ] = id;
    });
<<<<<<< HEAD
    console.log("roomHash: ", roomHash);
	console.log("Doc: ", doc);
=======
>>>>>>> bc0ca989abb6a021a6de9ec51f0e6b6921933916

    function refreshSVGMap() {
        $.each(roomHash, function (name, id) {
            //console.log(name, id);
            $.getJSON('/users/by-room/'+ encodeURIComponent(name) , function(data){
                //console.log(name, id, data);
                if( data ) {
                    $(doc).find('#'+id).text( data.length + ' hacker'+(data.length==1?'':'s'));
                } else {
                    $(doc).find('#'+id).text("NIL");
                }
            } );
        });
    }
    //refreshSVGMap();

    return {
        'refresh' : refreshSVGMap
    }
}
