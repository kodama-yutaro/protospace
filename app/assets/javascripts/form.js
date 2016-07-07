$(window).on('page:change', function () {
  $('#js-preview-images0').change(function(event){
    var file = event.target.files[0]
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function(e){
        var img = $("<img>");
        img.attr('src', e.target.result);
        $("#js-preview-images0").empty().append(img);
    };
  });

  $('#js-preview-images1').change(function(event){
    var file = event.target.files[0]
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function(e){
        var img = $("<img>");
        img.attr('src', e.target.result);
        $("#js-preview-images1").empty().append(img);
    };
  });

  $('#js-preview-images2').change(function(event){
    var file = event.target.files[0]
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function(e){
        var img = $("<img>");
        img.attr('src', e.target.result);
        $("#js-preview-images2").empty().append(img);
    };
  });

  $('#js-preview-images3').change(function(event){
    var file = event.target.files[0]
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function(e){
        var img = $("<img>");
        img.attr('src', e.target.result);
        $("#js-preview-images3").empty().append(img);
    };
  });
});
