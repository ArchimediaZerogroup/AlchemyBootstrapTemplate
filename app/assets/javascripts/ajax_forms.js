(function ($) {


    var print_results = function(element,result){
        if (result instanceof Array ){
            var resp = "";

            $.each(result,function(index,value){

                resp+= "<span>"+value+"</span>";

            });
            $(element).html(resp);
        }else{
            $(element).html(result)
        }
    };

    var add_errors= function(errors){

        $.each(errors,function(name,value){

            var input= $("input[name*='"+name+"']");

            $(input).addClass("invalid");
            $(input).parent().append("<span class='error-message'>"+value+"</span>");



        });
    }



    $(document).on("ajax:success", ".ajax_forms", function(event, response, status, error) {


        var form = this;
        var message_box = $(form).parent().find(".messages")[0];
        print_results(message_box,response.messages);
        $(message_box).addClass('ok');
        $(form).hide();
        //$('.reset').click();

    });


    $(document).on("ajax:error",".ajax_forms", function (event, xhr, status, error) {

        var form = this;
        var message_box = $(form).parent().find(".messages")[0];
        print_results(message_box,JSON.parse(xhr.responseText).messages);
        $(message_box).addClass('ko');
        add_errors(JSON.parse(xhr.responseText).errors);

     });

})(jQuery);