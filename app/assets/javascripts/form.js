$(window).on('page:change', function () {
    var number = ["0","1","2","3"];
 $.each(number, function(i){
  $("#js-preview-images"+i).change(function(event){
    var file = event.target.files[0]
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function(e){
        var img = $("<img>");
        img.attr('src', e.target.result);
        $("#js-preview-images"+i).empty().append(img);
   };
  });
 });
});
