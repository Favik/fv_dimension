$(function() {
    window.addEventListener('message', function(OpenMenu) {
        switch (OpenMenu.data.action) {
            case 'enable':
                $('#panel').fadeIn();
                $('#content-my').fadeIn();
                $('#price').html(OpenMenu.data.price);
                break;
            case 'showhud':
                $('#hud').fadeIn();
                $('#current_id').html(OpenMenu.data.current_id);
                break;
            case 'hidehud':
                $('#hud').fadeOut();
                break;
        }

    });

    $("#create").click(function () {
        var id = $("#id").val()
        var name = $("#name").val()
        var password = $("#password").val()
        if (id !== "" && name !== "") {
            $('#panel').fadeOut();
            $('#content-my').fadeOut();
            $.post('http://fv_dimension/action', JSON.stringify({
                    id: id,
                    name: name, 
                    password: password, 
                    action: 'create-dimension'
            }));
        }else{
            $.post('http://fv_dimension/action', JSON.stringify({
                action: 'error-create'
            }));
        }
    });

    $("#connect_to_id").click(function () {
        var id_connect = $("#id_connect").val()
        var passwd_connect = $("#passwd_connect").val()
        if (id_connect !== "") {
            $('#panel').fadeOut();
            $('#content-connect').fadeOut();
            $.post('http://fv_dimension/action', JSON.stringify({
                    id_connect: id_connect,
                    passwd_connect: passwd_connect, 
                    action: 'connect-dimension'
            }));
        }else{
            $.post('http://fv_dimension/action', JSON.stringify({
                    action: 'error-connect'
            }));
        }
    });

    $("#leave").click(function () {
        $('#panel').fadeOut();
        $('#content-connect').fadeOut();
        $.post('http://fv_dimension/action', JSON.stringify({
                action: 'leave-dimension'
            }));
    });

    $("#close").click(function () {
        $('#panel').fadeOut();
        $('#content-connect').fadeOut();
        $.post('http://fv_dimension/action', JSON.stringify({
                action: 'close-menu'
            }));
    });
    document.addEventListener('keyup', (e) => {
        if(e.key == 'Escape') {
            $('#panel').fadeOut();
            $('#content-connect').fadeOut();
                $.post('http://fv_dimension/action', JSON.stringify({
                    action: 'close-menu'
                }));
        }
    });
    
    $('#my').click(function () {
        document.getElementById("content-connect").style.display = "none";
        document.getElementById("content-my").style.display = "block";
    });
    $('#connect').click(function () {
        document.getElementById("content-my").style.display = "none";
        document.getElementById("content-connect").style.display = "block";
    });    

});